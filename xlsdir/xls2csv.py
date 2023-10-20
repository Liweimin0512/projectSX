from os import read
import os
import pandas as pd
import configparser
import utility

def read_excel(xls_file_path):
    # xls_df = pd.read_excel(xls_file_path, sheet_name="data@", engine='openpyxl', keep_default_na=False)
    excels = {}
    f = pd.ExcelFile(xls_file_path)
    for i in f.sheet_names:
        # d = pd.read_excel('./data.xlsx', sheetname=i)
        if "|" in i:
            excel_name = i.split("|")[0]
            data = pd.read_excel(xls_file_path, i)
            excels[excel_name] = data
            # print(data)
    return excels

def del_files(path_file):
    ls = os.listdir(path_file)
    for i in ls:
        f_path = os.path.join(path_file, i)
        # 判断是否是一个目录,若是,则递归删除
        if os.path.isdir(f_path):
            del_files(f_path)
        else:
            os.remove(f_path)


def tags_check(xls_datas, xls_col_index, tips_list, n, b_check):
    '''
    数据检查和报错
    '''
    # print(n)
    xls_datas[n] = [ str(x).replace('_x000D_','') for x in xls_datas[n]]
    
    if b_check:
        retain = 1
        if 'INT'in tips_list[n]:
            a = xls_datas[n][:retain]
            b = list(map(utility.set_int, xls_datas[n][retain:]))
            xls_datas[n] = a + b
        elif 'FLOAT' in tips_list[n]:
            a = xls_datas[n][:retain]
            b = list(map(utility.set_float, xls_datas[n][retain:]))
            xls_datas[n] = a + b
        elif 'STR' in tips_list[n]:
            xls_datas[n] = list(map(utility.set_str, xls_datas[n]))
        elif 'BOOL' in tips_list[n]:
            a = xls_datas[n][:retain]
            b = list(map(utility.set_int, xls_datas[n][retain:]))
            xls_datas[n] = a + b
        
        #数据作用域检测
        for t in tips_list[n]:
            if '>=' in t:
                num = float(t[2:])
                for i in range(len(xls_datas[n][retain:])):
                    item = xls_datas[n][retain:][i]
                    if not item >= num:
                        raise Exception( xls_col_index[n] + "列 第" + str(i + 3) +"行发现数据：" + str(item) + " < " + str(num))
            elif '>' in t:
                num = float(t[1:])
                for i in range(len(xls_datas[n][retain:])):
                    item = xls_datas[n][retain:][i]
                    if not item > num:
                        raise Exception( xls_col_index[n] + "列 第" + str(i + 3) +"行发现数据：" + str(item) + " <= " + str(num))
            if '<=' in t:
                num = float(t[2:])
                for i in range(len(xls_datas[n][retain:])):
                    item = xls_datas[n][retain:][i]
                    if not item <= num:
                        raise Exception( xls_col_index[n] + "列 第" + str(i + 3) +"行发现数据：" + str(item) + " > " + str(num))
            elif '<' in t:
                num = float(t[1:])
                for i in range(len(xls_datas[n][retain:])):
                    item = xls_datas[n][retain:][i]
                    if not item < num:
                        raise Exception( xls_col_index[n] + "列 第" + str(i + 3) +"行发现数据：" + str(item) + " >= " + str(num))
            if '==' in t:
                num = str(t[2:])
                for i in range(len(xls_datas[n][retain:])):
                    item = xls_datas[n][retain:][i]
                    if not item == num:
                        raise Exception( xls_col_index[n] + "列 第" + str(i + 3) +"行发现数据：" + str(item) + " != " + str(num))
            if '!=' in t:
                num = str(t[2:])
                for i in range(len(xls_datas[n][retain:])):
                    item = xls_datas[n][retain:][i]
                    if not item != num:
                        raise Exception( xls_col_index[n] + "列 第" + str(i + 3) +"行发现数据：" + str(item) + " == " + str(num))

        # 数据重复检测
        if 'NOREPEAT' in tips_list[n] or 'KEY' in tips_list[n]:
            check_list = [x for x in xls_datas[n] if x != '' and x != 0 ][1:]
            # assert len(check_list) == len(set(check_list))
            if len(check_list) != len(set(check_list)):
                raise Exception( "注意： " + xls_col_index[n] + " 列存在重复数据！！！")

        if 'KEY' in tips_list[n]:
            check_list = [x for x in xls_datas[n] if x != '' and x != 0 ][1:]
            # print(check_list)
            # print(sorted(check_list))
            if check_list != sorted(check_list) :
                print( "注意： " + xls_col_index[n] + " 列不是顺序的！！！")
              
        return xls_datas[n]

def export_all_xls(exl_file_path,csv_file_path):
    '''
    遍历文件夹进行转换
    '''
    print("导出全部data@的文件")
    print("excel文件所在目录：  " + exl_file_path)
    print("  csv文件所在目录：  " + csv_file_path)

    for root, dirs, files in os.walk(exl_file_path):

        # root 表示当前正在访问的文件夹路径
        # dirs 表示该文件夹下的子目录名list
        # files 表示该文件夹下的文件list

        # 遍历所有的文件夹
        for d in dirs:
            str = os.path.join(root, d)    
            csvdir = csv_file_path + str.replace(exl_file_path, '')
            if not os.path.exists(csvdir):
                os.mkdir(csvdir) # 创建目录
                # os.makedirs(path) 多层创建目录 

        # 遍历文件
        for f in files:
            if f.endswith(".xlsx") :
                exl_file = os.path.join(root, f)   
    # for f in xls_path_dict.values():
    #             exl_file = exl_file_path + f
                if "data@" in utility.get_excel_sheets(exl_file):
                    # print(exl_file)
                    print("开始操作：" + exl_file )
                    xls_df = read_excel(exl_file)
                    csv_file = csv_file_path + exl_file.replace(exl_file_path, '').replace(".xlsx","") + ".csv"
                    xls_df.to_csv(csv_file, encoding="utf-8-sig", index=False, float_format=None)
                    print(csv_file + " 操作完成!")

def export_by_file(exl_file_path,csv_file_path,exl_file_dict):
    '''
    根据文件名进行转换
    '''
    print("按名称导出data@的文件")
    print("excel文件所在目录：  " + exl_file_path)
    print("  csv文件所在目录：  " + csv_file_path)
    for xls in exl_file_dict.values():
        print("开始操作：" + exl_file_path + xls )
        xls_df = read_excel(exl_file_path + xls)
        for xls in xls_df.keys():
            data = xls_df[xls]
            csv_file = csv_file_path + xls + ".csv"
            data.to_csv(csv_file, encoding="utf-8-sig",  index=False, float_format=None)
        # csv_file = csv_file_path + xls.replace(exl_file_path, '').replace(".xlsx","") + ".csv"
        # xls_df.to_csv(csv_file, encoding="utf-8-sig", index=False, float_format=None)
            import_file = open(csv_file + ".import",mode='w')
            import_file.write("[remap]\n\nimporter=\"keep\"\n")
            import_file.close
            print(csv_file + " 操作完成!")


def main():
    try:             
        config = configparser.ConfigParser()
        config.read(utility.resource_path('cfg_export.ini'),encoding='utf-8')

        xls_file_path = os.path.abspath(config.get("filePath","xls_file_path")) + "/"
        csv_file_path = os.path.abspath(config.get("filePath","csv_file_path")) + "/"
        export_mode = int(config.get("option","export_mode"))

        xls_path_list = config.items('xlsName')
        xls_path_dict = dict(zip([x[0] for x in xls_path_list],[x[1] for x in xls_path_list]))

        print("========= 开始数据转换 ===========")
        del_files(csv_file_path)
        if export_mode == 1:
            export_all_xls(xls_file_path, csv_file_path)
        elif export_mode == 2:
            export_by_file(xls_file_path, csv_file_path, xls_path_dict)
        else:
            raise Exception("未知的导出模式，请确认配置文件!!")
        print("========= 数据转换完成 ===========")

    except Exception as r:
        input("存在异常"+ str(r) +"请按任意键关闭此界面手动处理>")
    else:
        input("完成操作，按任意键结束 >")

if __name__ == '__main__':
    main()