# NOTE: Make sure to import any new process profilers to load it
from gprofiler.profilers.perf import SystemProfiler
from gprofiler.profilers.python import PythonProfiler
from granulate_utils import is_windows
if not is_windows():
    from gprofiler.profilers.dotnet import DotnetProfiler
    from gprofiler.profilers.java import JavaProfiler
    from gprofiler.profilers.php import PHPSpyProfiler
    from gprofiler.profilers.ruby import RbSpyProfiler
from gprofiler.profilers.python_ebpf import PythonEbpfProfiler
>>>>>>> f5f809b... Moved implementation for PythonEbpfProfiler and PythonEbpfError to its on file. Addressed other issues raised during the PR review

__all__ = (["JavaProfiler", "SystemProfiler", "PHPSpyProfiler", "PythonProfiler", "RbSpyProfiler", "DotnetProfiler"]\
           if not is_windows()\
           else ["PythonProfiler", "SystemProfiler"])
