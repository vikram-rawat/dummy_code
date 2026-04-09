# --- Project-specific startup ---
using Pkg
using Revise

# Load .env
load_env_file(joinpath(@__DIR__, ".env"))

# Define where your environments live (customizable!)
env_root = joinpath(@__DIR__, ".julia")

# Activate dev/prod based on JULIA_DEFAULT_ENV
activate_env_from_var(env_root)
