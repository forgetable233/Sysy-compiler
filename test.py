import subprocess
import numpy as np
import os
import sys
import time
from array import array

argument = sys.argv
if len(argument) != 5:
    print('the size of the input args is not correct')
    sys.exit(1)

exec_folder = './outs/new_exec/'
test_folder = './tests/'
out_folder = './outs/out/'
sy_folder = './tests/sy/'
ll_folder = './outs/ll/'
obj_folder = './outs/objs/'
lib_tar = './lib/sylib.a'

if_compile = int(argument[1])
generate_ll_o = int(argument[2])
generate_exec = int(argument[3])
test = int(argument[4])

## 首先进行编译
if if_compile == 1:
    ins = 'make -j8'
    work_dict = './build/'
    process = subprocess.Popen(ins, shell=True, cwd=work_dict)
    process.wait()
    if process.returncode == 0:
        print('compile succeed')
    else:
        print('compile failed')

## 首先遍历生成所有的.ll与.o文件
if generate_ll_o == 1:
    input_ll_folder = '../tests/'
    ins = './minic '
    work_dict = './build/'
    for root, folder, files in os.walk(sy_folder):
        for file in sorted(files):
            file_path = os.path.join(input_ll_folder, file)
            exec_ins = ins + file_path
            process = subprocess.Popen(exec_ins, shell=True, cwd=work_dict)
            process.wait()
            if process.returncode != 0:
                print(file)
    rm_ins = 'rm outs/obj/*.o'
    mv_ins = 'mv build/*.o outs/objs/'
    subprocess.run(rm_ins, shell=True)
    subprocess.run(mv_ins, shell=True)

if generate_exec == 1:
    for root, folder, files in os.walk(obj_folder):
        for file in sorted(files):
            exec = file[:-2]
            exec_path = os.path.join(exec_folder, exec)
            obj_path = os.path.join(obj_folder, file)
            ins = 'clang -o ' + exec_path + ' ' + obj_path + ' -L ' + lib_tar
            process = subprocess.Popen(ins, shell=True)

if test == 1:
    count = 0
    error_list = []
    time_out = 1
    for root, folder, files in os.walk(exec_folder):
        for file in sorted(files):
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
            if os.path.exists(in_file):
                with open(in_file, 'r') as input_file:
                    content = input_file.read()
                    process = subprocess.Popen([exec_file], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
                    std_out, error = process.communicate(content.encode())
                    process.wait()
                    return_code = process.returncode
                    with open(process_out_result, 'w') as process_out:
                        if std_out != '':
                            process_out.write(std_out.decode())
                        if return_code is not None:
                            process_out.write(str(return_code))

            else:
                process = subprocess.Popen([exec_file], stdout=subprocess.PIPE)
                std_out, error = process.communicate()
                process.wait()
                return_code = process.returncode
                with open(process_out_result, 'w') as process_out:
                    if std_out != '':
                        process_out.write(std_out.decode())
                    if return_code is not None:
                        process_out.write(str(return_code))
            data = None
            with open(process_out_result, 'r') as temp_file:
                data = temp_file.read()
            data = data.replace(' ', '').replace('\n', '')
            tar_result = tar_result.replace('', '').replace('\n', '')
            if data == tar_result:
                count = count + 1
            else:
                print(file)
    print('the number is ', count)
