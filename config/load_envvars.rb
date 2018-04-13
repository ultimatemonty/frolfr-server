# Attempt to load env vars from various locations
# First we check the users homedir
# Then we check the local directory
# Note that local files will always override user files
%w[development production test].each do |env|
  found_env = false

  # attempt to load env files out of the user dir
  env_filename = File.expand_path("~/envvars_frolfr_#{env}")
  if File.exist?(env_filename)
    load(env_filename)
    found_env = true
  end

  # load local env files, note this will step on anything in the user dir
  env_filename = File.expand_path(File.join(File.dirname(__FILE__), "..", ".envvars_#{env}.rb").to_s)
  if File.exist?(env_filename)
    load(env_filename)
    found_env = true
  end

  break if found_env
end