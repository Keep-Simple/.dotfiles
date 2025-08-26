export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=us-east-1
export ANTHROPIC_MODEL='us.anthropic.claude-sonnet-4-20250514-v1:0'
export ANTHROPIC_SMALL_FAST_MODEL='us.anthropic.claude-sonnet-4-20250514-v1:0'
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=32000

# Note: You may recieve 429 errors if it does a lot of parallel tool calling, so reduce CLAUDE_CODE_MAX_OUTPUT_TOKENS if you face this issue. Also intentionally set both ANTHROPIC_MODEL and ANTHROPIC_SMALL_FAST_MODEL to sonnet 4 as default Opus 4 model is costly and sonnet 4 is good enough in my usage.
# 4. Run claude in your project folder.
# Bonus is that it has IDE extensions so you can review the code diff's in IDE before accepting. So run /ide command to set it up.
