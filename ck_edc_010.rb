#! C:/Ruby33-x64/bin ruby
# coding: cp932
# -*- cording: cp932 -*-
# vim:set fileencoding=cp932
#
# Encords: UTF-8   / EUC-JP / cp932   / MacJapanese / Shift_JIS / ISO-2022-JP / US-ASCII 
# Use by : UniCode / Unix   / Windows / Mac         / MS-DOS    / e-mail (jp) / USA
# 
# ck_edc : Check Environment Dependency Character
#
# Vrsion/Edition/BugFix : 0.1.0 Initial Edition
#
# ファイル内に環境依存文字が使われているか否かをチェックします。チェックする文字コードの指定ができます。
# 対象のファイル形式は、テキストファイル(.txt)、CSVファイル(.csv)、EXCELファイル(.xls .xlsx)、
#                   設定ファイル(.cnf .conf .ini .init .rc .xml .setings など),
#                   プログラムソース(.c cpp .rb .py .java .js .php .html など)です。
# 
#【使い方】
# 「Start Command Prompt with Ruby」又は「Debian」を開いて、コマンドラインで下線部を入力します。
#      C:>ck_edc.rb ファイル名(パス含む)
#         ==================
#
begin

def help_msg
  $stderr.printf("【使用法】\n")
  $stderr.printf("ck_edc.rb [コマンド] 指定ファイル名 [>結果ファイル名]\n")
  $stderr.printf("【ヘルプ】\n")
  $stderr.printf("ck_edc.rb -? \t ヘルプ表示（この表示）\n")
  $stderr.printf("【コマンド】\n")
  $stderr.printf(" [-自動修正] -入力文字コード -出力文字コード \n")
  $stderr.printf("    -f：自動修正処理を行う\n")
  $stderr.printf("    文字コード（入力、出力とも）\n")
  $stderr.printf("    -uni： Unicode(UTF8), -win : Windows(CP932), -dos : MS-DOS(Shift-JIS),\n")
  $stderr.printf("    -mac : MacJP(old) , -euc : Unix(EUC-JP), -jis : JIS(ISO-2022-JP:7bit),\n")
  $stderr.printf("    -excel : Excel用のBOM付きUnicode(UTF8), メモ帳などはBOM無しUniCode(UTF8).\n")
  $stderr.printf("【使用例】\n")
  $stderr.printf("ck_edc.rb -win -dos 指定ファイル名\n")
  $stderr.printf("    Windowsコードの指定ファイルの機種依存文字を、Shift-JISコードでチェックして表示\n")
  $stderr.printf("ck_edc.rb -win -uni 指定ファイル名 >結果ファイル名 \n")
  $stderr.printf("    Windowsコードの指定ファイルの機種依存文字を、Unicode(UTF8)コードでチェックして\n")
  $stderr.printf("    結果ファイル(.check)に保存\n")
  $stderr.printf("ck_edc.rb -f -uni -excel 指定ファイル名 >結果ファイル名 \n")
  $stderr.printf("    Unicode(UTF8)の指定ファイルの機種依存文字を、EXCEL(BOM付きUTF-8)コードで可能な限り\n")
  $stderr.printf("    自動修正し結果ファイル(_excel)に保存\n")
  $stderr.printf("ck_edc.rb -f -uni -win 指定ファイル名 >結果ファイル名 \n")
  $stderr.printf("    Unicode(UTF8)の指定ファイルの機種依存文字を、Windows(cp932)コードで可能な限り\n")
  $stderr.printf("    自動修正し結果ファイル(_cp932)に保存\n")
  $stderr.printf("【備考：表示可能文字の範囲】\n")
  $stderr.printf("    JISやShift-JISの漢字コードにNEC PC9801とIBM PS/55の外字を加えたものがCP932(Windows)コード。\n")
  $stderr.printf("    JISやShift-JISの漢字コードにMacOS9までの外字を加えたものがMacJPコード(新MacはUnicode(UTF8))。\n")
  $stderr.printf("    JISやShift-JISの漢字コードに各社Unix機の外字を加えたものがEUC-JPコード(LinuxはUnicode(UTF8)。\n")
  $stderr.printf("    Unicodeは全世界の文字を表現し得るコードで、国を問わないインターネット普及で一気に標準となった。\n")
  $stderr.printf("    UnicodeにはUTF8(1-4Byte/文字), UTF16(2Byte/文字・制限あり), UTF32(4Byte/文字)がある。\n")
  $stderr.printf("    Android/i-PhoneのスマホやiPad等のタブレット、パソコンのブラウザ等、多くがUTF8を標準としている。\n")  
  $stderr.printf("    現時点ではUTF8が世界標準で、Windowsのメモ帳もUTF8。但しWindowsのEXCELではBOM付きUTF8かCP932、\n")
  $stderr.printf("    Windowsのフォルダ名やファイル名はUTF32が使われる。尚、UTF16とUTF32にはByte順を示すBOMが必須。\n")
  $stderr.printf("    コマンドプロンプトでは、chcp 932 でCP932コード、chch 65001 でUTF8コード、chcp 51932 でEUC-JP\n")
  $stderr.printf("    コード、chcp 1200 でUTF16コードに変わります。chcp だけで現在設定されているコードを表示します。\n")
    
end

# #### init ####
flag_fix = nil
flag_bom_in = nil
flag_bom_out = nil
bom = "\FEFE"
file_name = nil
edc_count = 0
enc_input = Encoding.default_external
enc_output = Encoding.default_external
enc_internal = Encoding.default_internal

if ARGV.empty?
  help_msg()
  exit
end

case ARGV[0]
  when "-?", "-h", "--help", "/?", "/h", "/help"
    help_msg()
    exit
  when "-f", "-F", "/f", "/F"
    flag_fix = true
    case ARGV[1]
      when "-uni", "-UNI", "/uni", "/UNI"
        enc_input = 'UTF-8'
      when "-win", "-WIN", "/win", "/WIN"
        enc_input = 'CP932'
      when "-dos", "-DOS", "/dos", "/DOS"
        enc_input = "Shift_JIS"
      when "-mac", "-MAC", "/mac", "/MAC"
        enc_input = "MacJapan"
      when "-euc", "-EUC", "/euc", "/EUC"
        enc_input = "EUC-JP"
      when "-jis", "-JIS", "/jis", "/JIS"
        enc_input = "ISO-2022-JP"
      when "-excel", "-EXCEL", "/excel", "EXCEL"
        enc_input = "UTF-8"
        flag_bom_input = true
      else
        enc_input = Encoding.default_external
    end
    enc_internal = enc_input
    case ARGV[2]
      when "-uni", "-UNI", "/uni", "/UNI"
        enc_output = 'UTF-8'
      when "-win", "-WIN", "/win", "/WIN"
        enc_output = 'CP932'
      when "-dos", "-DOS", "/dos", "/DOS"
        enc_output = "Shift_JIS"
      when "-mac", "-MAC", "/mac", "/MAC"
        enc_output = "MacJapan"
      when "-euc", "-EUC", "/euc", "/EUC"
        enc_output = "EUC-JP"
      when "-jis", "-JIS", "/jis", "/JIS"
        enc_output = "ISO-2022-JP"
      when "-excel", "-EXCEL", "/excel", "EXCEL"
        enc_output = "UTF-8"
        flag_bom_out = true
      else
        enc_output = Encoding.default_external
    end
    file_name = ARGV[3]
  else
    flag_fix = nil
    case ARGV[0]
      when "-uni", "-UNI", "/uni", "/UNI"
        enc_input = 'UTF-8'
      when "-win", "-WIN", "/win", "/WIN"
        enc_input = 'CP932'
      when "-dos", "-DOS", "/dos", "/DOS"
        enc_input = "Shift_JIS"
      when "-mac", "-MAC", "/mac", "/MAC"
        enc_input = "MacJapan"
      when "-euc", "-EUC", "/euc", "/EUC"
        enc_input = "EUC-JP"
      when "-jis", "-JIS", "/jis", "/JIS"
        enc_input = "ISO-2022-JP"
      when "-excel", "-EXCEL", "/excel", "EXCEL"
        enc_input = "UTF-8"
        flag_bom_in = true
      else
        enc_input = Encoding.default_external
    end
    enc_internal = enc_input
    case ARGV[1]
      when "-uni", "-UNI", "/uni", "/UNI"
        enc_output = 'UTF-8'
      when "-win", "-WIN", "/win", "/WIN"
        enc_output = 'CP932'
      when "-dos", "-DOS", "/dos", "/DOS"
        enc_output = "Shift_JIS"
      when "-mac", "-MAC", "/mac", "/MAC"
        enc_output = "MacJapan"
      when "-euc", "-EUC", "/euc", "/EUC"
        enc_output = "EUC-JP"
      when "-jis", "-JIS", "/jis", "/JIS"
        enc_output = "ISO-2022-JP"
      when "-excel", "-EXCEL", "/excel", "EXCEL"
        enc_output = "UTF-8"
        flag_bom_out = true
      else
        enc_output = Encoding.default_external
    end
    file_name = ARGV[2]
end

$stderr.printf("Input.ENC = %s \n", enc_input)
$stderr.printf("Output.ENC = %s \n", enc_output)
$stderr.printf("Internal.ENC = %s \n", enc_internal)
current_directory = Dir.pwd
full_path = current_directory + '/' + file_name
read_mode = 'r:' + enc_input + ':' + enc_internal

    p 'ARGV ', ARGV[0], ARGV[1], ARGV[2], ARGV[3]
    p 'flag_fix ', flag_fix
    p 'flag_bom_in ', flag_bom_in
    p 'flag_bom_out ', flag_bom_out
    p 'bom ', bom
    p 'edc_count ', edc_count
    p 'file_name ', file_name
    p 'current_directory', current_directory
    p 'full_path', full_path
    p 'enc_input ', enc_input
    p 'enc_output ', enc_output
    p 'enc_internal ', enc_internal
    p 'Fine.open()', full_path, read_mode

    if FileTest.exist?(full_path) == true
      fp=File.open(full_path, read_mode)
      $stderr.printf("<<%s>> を%sコードで開きます。\n", file_name, enc_input)
    else
      $stderr.printf("<<%s>> 指定ファイルが存在しません、ファイル名を確認してください。\n", file_name)
      exit
    end

row=0
fp.each_line do |line|
  $stdout.printf("ファイル %s の文字コード・エンコーディングは %s です。\n", file_name, line.encoding)
  line.chomp!
  row+=1
  $stdout.printf("=== 行=%d \t 文字長=%d \t 文字列= %s ===\n", row, line.length, line)
  col=0
  $stdout.printf("列 \t 文字 \t 16進 \t 10進 \t 2進\n")
  line.each_char do |char|
    col+=1
    $stdout.printf("%d \t %c \t %x \t %i\ \t %b\n", col, char.ord, char.ord, char.ord, char.ord)
  end
  $stdout.printf("==== EDC=%d ====\n", edc_count)
end

fp.close

end

# rescue => except
#  $stderr.puts except.message
#  $stderr.puts except.class
#  $stderr.puts except.backtrace
# end

