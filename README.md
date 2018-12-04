## StackStorm Windows Runner

This repository contains source code for winexe based StackStorm Windows
runner.

This runner is not officially supported by the StackStorm team anymore.

Runner can still be installed and used, but there will be no official support
provider for it by the StackStorm team.

### Installing the Runner

```bash
/opt/stackstorm/st2/bin/pip install "git+https://github.com/stackstorm/stackstorm-runner-windows.git#egg=stackstorm-runner-windows"

sudo st2ctl reload --register-runners
```

### Background / Context

In StackStorm v3.1.0, Windows runner has been deprecated in favor of the new
WinRM Windows runner and moved out of the StackStorm base distribution.
