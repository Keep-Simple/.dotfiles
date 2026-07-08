# claude-vertex: uses Vertex AI (default, set in ~/.zshenv)
alias claude='claude --allow-dangerously-skip-permissions'

# claude-direct: uses Anthropic direct (OAuth via `claude auth login`)
claude-direct() {
  env -u CLAUDE_CODE_USE_VERTEX \
      -u ANTHROPIC_VERTEX_PROJECT_ID \
      -u CLOUD_ML_REGION \
      claude --allow-dangerously-skip-permissions "$@"
}
