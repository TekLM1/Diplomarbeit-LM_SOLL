#!/usr/bin/env bash
git fetch --depth 50 origin master:master # fetch the master branch

error=0

# If the current branch is master, run a full check
if [ "$CI_COMMIT_REF_NAME" = "$CI_DEFAULT_BRANCH" ];then
  echo "ℹ️ INFO - Running on $CI_COMMIT_REF_NAME branch. Checking all files."

  # Run TFLint for linting
  tflint --init --chdir "$SECURITY_CONF_DIR" --config "./.tflint-config.hcl"
  tflint --chdir "$TF_ROOT" --config "./security-conf/.tflint-config.hcl"
  if [ $? -ne 0 ]; then
    echo "⚠️ ERROR - TFLint detected findings or vulnerabilities."
    error=1
  else
    echo "ℹ️ INFO - TFLint run successful, no findings."
  fi

  # Run Trivy for configuration scanning
  trivy repo "$TF_ROOT" --config "$SECURITY_CONF_DIR/.trivy.yaml" --ignorefile "$SECURITY_CONF_DIR/.trivyignore"
  if [ $? -ne 0 ]; then
    echo "⚠️ ERROR - Trivy found findings or vulnerabilities."
    error=1
  else
    echo "ℹ️ INFO - Trivy run successful, no findings."
  fi

# If the current branch is not master, check only updated files
else
  # Get all the files which were updated in this branch
  updatedFiles=$(git diff --diff-filter=AMR --name-only "origin/master..origin/$CI_COMMIT_REF_NAME")
  echo "ℹ️ INFO - Running on feature branch: $CI_COMMIT_REF_NAME"
  if [ $? -ne 0 ];then
    echo "⚠️ ERROR - Failed to get the list of updated files."
    exit 1
  fi

  # Iterate over updated files and run security scans
  for file in $updatedFiles;do
    if [[ "$file" == *.tf && -f "$file" ]];then
      echo "ℹ️ INFO - Running security scans on updated file: $file"

      # Run TFLint for linting
      tflint --init --chdir "$SECURITY_CONF_DIR" --config "./.tflint-config.hcl"
      tflint --chdir "$TF_ROOT" --config "./security-conf/.tflint-config.hcl"
      if [ $? -ne 0 ]; then
        echo "⚠️ ERROR - TFLint detected findings or vulnerabilities in $file."
        error=1
      else
        echo "ℹ️ INFO - TFLint run successful on $file, no findings."
      fi

      # Run Trivy for configuration scanning
      trivy repo "$file" --config "$SECURITY_CONF_DIR/.trivy.yaml" --ignorefile "$SECURITY_CONF_DIR/.trivyignore"
      if [ $? -ne 0 ]; then
        echo "⚠️ ERROR - Trivy found findings or vulnerabilities in $file."
        error=1
      else
        echo "ℹ️ INFO - Trivy run successful on $file, no findings."
      fi
    fi
  done
fi

# Overall check, fail if any tool reported issues
if [ "$error" -ne 0 ]; then
  echo "❌ FAIL - Security scan failed, vulnerabilities or issues found."
  echo "Please fix the reported issues above before proceeding."
  exit 1
else
  echo "✅ PASS - All security scans passed, no vulnerabilities found. Cheers."
fi
