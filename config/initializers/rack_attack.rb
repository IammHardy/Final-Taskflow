# Use memory store for rate limiting to avoid solid_cache dependency
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
class Rack::Attack
  # Allow all local traffic
  safelist("allow-localhost") do |req|
    req.ip == "127.0.0.1" || req.ip == "::1"
  end

  # Throttle AI endpoints — max 10 requests per minute per user
  throttle("ai/user", limit: 10, period: 1.minute) do |req|
    if req.path.start_with?("/ai/")
      req.env["warden"]&.user&.id
    end
  end

  # Throttle AI endpoints by IP as fallback — 20 per minute
  throttle("ai/ip", limit: 20, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/ai/")
  end

  # General API throttle — 60 requests per minute per IP
  throttle("req/ip", limit: 60, period: 1.minute) do |req|
    req.ip unless req.path.start_with?("/assets")
  end

  # Block suspicious login attempts — 5 per 20 seconds per IP
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == "/users/sign_in" && req.post?
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |req|
    match_data = req.env["rack.attack.match_data"]
    now        = match_data[:epoch_time]
    retry_after = match_data[:period] - (now % match_data[:period])

    [
      429,
      {
        "Content-Type"  => "application/json",
        "Retry-After"   => retry_after.to_s
      },
      [{ error: "Too many requests. Please wait #{retry_after} seconds." }.to_json]
    ]
  end
end