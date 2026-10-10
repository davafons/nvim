-- Homebrew JDKs are not registered with macOS's /usr/bin/java shim.
-- Use the installed Java 21 runtime for Java/Kotlin tools inside Neovim.
if not vim.env.JAVA_HOME then
  for _, prefix in ipairs({ "/opt/homebrew", "/usr/local" }) do
    local home = prefix .. "/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
    if vim.fn.executable(home .. "/bin/java") == 1 then
      vim.env.JAVA_HOME = home
      vim.env.PATH = home .. "/bin:" .. vim.env.PATH
      break
    end
  end
end
