#!/bin/bash

# List of asdf plugins with optional URLs
plugins=(
  "python"
  "pipenv https://github.com/and-semakin/asdf-pipenv.git"
  "nodejs"
  "jq"
  "yq"
  "deno"
  "pnpm"
  "rust"
  "golang"
  "kubectl"
  "helm"
  "kustomize"
	"skaffold"
  "dotnet-core"
  "terraform"
  "tfsec"
  "tflint"
  "tfcmt"
  "awscli"
  "terragrunt"
  "minikube"
  "air"
  "flutter"
  "okteto"
  "kompose"
  "trivy"
  "argocd"
  "oci"
  "golangci-lint"
	"cloudflared"
	"hugo"
)

# Adding plugins
for plugin_info in "${plugins[@]}"; do
  plugin_name=$(echo "$plugin_info" | awk '{print $1}')
  plugin_url=$(echo "$plugin_info" | awk '{print $2}')

  if asdf plugin list | grep -q "^${plugin_name}$"; then
    echo "[INFO] ${plugin_name} is already added."
  else
    echo "[INFO] Adding ${plugin_name}..."
    if [ -n "$plugin_url" ]; then
      # Add plugin with URL
      if asdf plugin-add "$plugin_name" "$plugin_url"; then
        echo "[SUCCESS] ${plugin_name} has been added from ${plugin_url}."
      else
        echo "[ERROR] Failed to add ${plugin_name} from ${plugin_url}."
      fi
    else
      # Add plugin without URL
      if asdf plugin-add "$plugin_name"; then
        echo "[SUCCESS] ${plugin_name} has been added."
      else
        echo "[ERROR] Failed to add ${plugin_name}."
      fi
    fi
  fi
done

echo "All plugin additions are complete."
