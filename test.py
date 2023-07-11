import subprocess
import numpy as np
import os
import sys
import time
import tqdm
from array import array

argument = sys.argv
if len(argument) != 6:
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
use_clang = int(argument[5])

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

begin_time_obj = time.process_time()
## 首先遍历生成所有的.ll与.o文件
if generate_ll_o == 1:
    input_ll_folder = '../tests/'
    ins = './minic '
    work_dict = './build/'
    for root, folder, files in os.walk(sy_folder):
        files = sorted(files)
        for file in sorted(files):
            file_path = os.path.join(input_ll_folder, file)
            exec_ins = ins + file_path
            process = subprocess.Popen(exec_ins, shell=True, cwd=work_dict)
            process.wait()
            if process.returncode != 0:
                print(file)
    rm_ins = 'rm outs/obj/*.o'
    mv_ins = 'mv build/*.o outs/objs/'
    # subprocess.run(rm_ins, shell=True)
    subprocess.run(mv_ins, shell=True)
end_time_obj = time.process_time()

begin_time_exec = time.process_time()
if generate_exec == 1:
    for root, folder, files in os.walk(obj_folder):
        for file in sorted(files):
            exec = file[:-2]
            exec_path = os.path.join(exec_folder, exec)
            obj_path = os.path.join(obj_folder, file)
            ins = 'clang -o ' + exec_path + ' ' + obj_path + ' -L ' + lib_tar
            process = subprocess.Popen(ins, shell=True)
end_time_exec = time.process_time()

exec_begin = time.process_time()
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
exec_end = time.process_time()

clang_obj_begin = time.process_time()
clang_obj_end = time.process_time()
clang_exec_begin = time.process_time()
clang_exec_end = time.process_time()
exec_clang_begin = time.process_time()
exec_clang_end = time.process_time()
clang_folder = './outs/clang_ll/'
clang_obj_folder = './outs/clang_objs/'
clang_exec_folder = './outs/clang_exec/'
if use_clang == 1:
    input_ll_folder = '../tests/'
    for root, folder, files in os.walk(sy_folder):
        for file in sorted(files):
            print('\n=====================================================')
            print('current test file is ', file)
            ll_file_name = file[:-2] + 'll'
            obj_file_name = file[:-2] + 'o'
            exec_file_name = file[:-3]
            c_root = './tests/c/'
            tar_file = os.path.join(c_root, file)
            print(tar_file)
            minic_ll_file_name = os.path.join(ll_folder, ll_file_name)
            minic_obj_file_name = os.path.join(obj_folder, obj_file_name)
            minic_exec_file_name = os.path.join(exec_folder, exec_file_name)
            clang_ll_file_name = os.path.join(clang_folder, ll_file_name)
            clang_obj_file_name = os.path.join(clang_obj_folder, obj_file_name)
            clang_obj_exec_file_name = os.path.join(clang_exec_folder, exec_file_name)
            clang_shell_ll = 'clang -emit-llvm -S ' + tar_file[:-2] + 'c' + ' -o ' + clang_ll_file_name
            clang_shell_obj = 'llc -filetype=obj ' + clang_ll_file_name + ' -o ' + clang_obj_file_name
            # print(clang_shell_obj)
            clang_obj_begin = time.process_time()
            subprocess.run(clang_shell_ll, shell=True)
            subprocess.run(clang_shell_obj, shell=True)
            clang_obj_end = time.process_time()
            print('The time by clang to generate obj file is ', clang_obj_end - clang_obj_begin)

            minic_shell = './minic ' + os.path.join(input_ll_folder, file)
            minic_obj_begin = time.process_time()
            subprocess.run(minic_shell, shell=True, cwd='./build')
            minic_obj_end = time.process_time()
            print('The time used by minic to generate obj file is ', minic_obj_end - minic_obj_begin)

            print('Faster ', clang_obj_end - clang_obj_begin - (minic_obj_end - minic_obj_begin))
            minic_obj_path = './outs/objs/' + file[:-2] + 'o'
            clang_obj_size = os.path.getsize(clang_obj_file_name)
            minic_obj_size = os.path.getsize(minic_obj_path)
            clang_exec_path = os.path.join(clang_exec_folder, file[:-3])
            print(clang_exec_path)
            link = 'gcc -o ' + clang_exec_path + ' ' + clang_obj_file_name + ' -L ' + './lib/sylib.o'
            subprocess.run(link, shell=True)
            print('The size of the clang obj is ', clang_obj_size)
            print('The size of the minic obj is ', minic_obj_size)

            # print(minic_exec_file_name)
            # clang_exec_size = os.path.getsize(clang_exec_path)

            # minic_exec_path = os.path.getsize()
            print('=====================================================')


print("The time used to generate all obj is ", end_time_obj - begin_time_obj)
print('The time used to generate all exec is ', end_time_exec - begin_time_exec)
print('The time used to exec all file is ', exec_end - begin_time_exec)
