local status_ok, avante = pcall(require, 'avante')
if not status_ok then
  return
end


local opts = {
  -- add any opts here
  -- for example
  provider="openai",
  openai_o3 = {
    endpoint = "https://api.openai.com/v1",
    model = "o3-mini", -- your desired model (or use gpt-4o, etc.)
    timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
    temperature = 0,
    max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
  },
  openai_4o = {
    endpoint = "https://api.openai.com/v1",
    model = "chatgpt-4o", -- your desired model (or use gpt-4o, etc.)
    timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
    temperature = 0,
    max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
  },
  claude_3_7 = {
    endpoint = "https://api.anthropic.com/v1", -- hypothetical endpoint for Claude
    model = "claude-3.7", -- your desired model
    timeout = 30000, -- Timeout in milliseconds
    temperature = 0,
    max_completion_tokens = 8192, -- Adjust as needed
    --reasoning_effort = "medium", -- low|medium|high, if applicable
  },
}

function SetAvanteProvider(new_provider)
  opts.provider = new_provider
  avante.setup(opts)
end

avante.setup(opts)
