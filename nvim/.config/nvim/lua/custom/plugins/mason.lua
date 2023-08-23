
return {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "pyright",
        "black",
        "ruff",
        "mypy",
      },
    },
}
