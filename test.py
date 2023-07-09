import subprocess
import numpy as np
import os
import time
from array import array

exec_folder = './outs/exec/'
test_folder = './tests/'
out_folder = './outs/out/'
count = 0
time_out = 1
for root, folder, files in os.walk(exec_folder):
    for file in sorted(files):
        print(file)
        in_file = os.path.join(test_folder, file)
        in_file += '.in'
        out_file = os.path.join(test_folder, file)
        out_file += '.out'
        exec_file = os.path.join(exec_folder, file)

        process_out_result = os.path.join(out_folder, file)
        process_out_result += '.out'
        tar_result = None
        with open(out_file, 'r') as output_file:
            tar_result = output_file.read()
        print(tar_result)
        if os.path.exists(in_file):
            with open(in_file, 'r') as input_file:
                content = input_file.read()
                process = subprocess.Popen([exec_file], stdin=subprocess.PIPE)
                process.communicate(content.encode())
                start_time = time.time()
                while process.poll() is None:
                    if time.time() - start_time > time_out:
                        process.terminate()
                        break
                process.wait()
                return_code = process.returncode
                std_out = process.stdout
            with open(process_out_result, 'w') as process_out:
                if std_out is not None:
                    process_out.write(std_out.read().decode())
                if return_code is not None:
                    process_out.write(str(return_code))

        else:
            process = subprocess.Popen([exec_file])
            start_time = time.time()
            while process.poll() is None:
                if time.time() - start_time > time_out:
                    process.terminate()
                    break
            process.wait()
            return_code = process.returncode
            std_out = process.stdout
            with open(process_out_result, 'w') as process_out:
                if std_out is not None:
                    process_out.write(std_out.read().decode())
                if return_code is not None:
                    process_out.write(str(return_code))