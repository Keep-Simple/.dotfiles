# claude-vertex: uses Vertex AI (default, set in ~/.zshenv)
# `command` bypasses the `claude` function below, which would otherwise strip these vars
alias claude-vertex='command claude --allow-dangerously-skip-permissions --model opusplan'

# claude-direct: uses Anthropic direct (OAuth via `claude auth login`)
claude() {
  env -u CLAUDE_CODE_USE_VERTEX \
      -u ANTHROPIC_VERTEX_PROJECT_ID \
      -u CLOUD_ML_REGION \
      claude --allow-dangerously-skip-permissions "$@"
}
