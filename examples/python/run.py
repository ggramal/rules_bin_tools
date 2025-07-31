import subprocess
import os

GLAB_EXECUTABLE=os.environ["GLAB_EXECUTABLE"]

result = subprocess.run([GLAB_EXECUTABLE, "--help"], capture_output=True, text=True)

print(result.stdout)
