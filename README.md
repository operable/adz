# Adz: A tool for shaping logs

## Configuration

```elixir
config :logger, :console,
  metadata: [:module, :line],
  format: {Adz, :text}
```

## Usage

```elixir
   use Adz
```
