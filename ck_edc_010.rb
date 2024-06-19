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
# �t�@�C�����Ɋ��ˑ��������g���Ă��邩�ۂ����`�F�b�N���܂��B�`�F�b�N���镶���R�[�h�̎w�肪�ł��܂��B
# �Ώۂ̃t�@�C���`���́A�e�L�X�g�t�@�C��(.txt)�ACSV�t�@�C��(.csv)�AEXCEL�t�@�C��(.xls .xlsx)�A
#                   �ݒ�t�@�C��(.cnf .conf .ini .init .rc .xml .setings �Ȃ�),
#                   �v���O�����\�[�X(.c cpp .rb .py .java .js .php .html �Ȃ�)�ł��B
# 
#�y�g�����z
# �uStart Command Prompt with Ruby�v���́uDebian�v���J���āA�R�}���h���C���ŉ���������͂��܂��B
#      C:>ck_edc.rb �t�@�C����(�p�X�܂�)
#         ==================
#
begin

def help_msg
  $stderr.printf("�y�g�p�@�z\n")
  $stderr.printf("ck_edc.rb [�R�}���h] �w��t�@�C���� [>���ʃt�@�C����]\n")
  $stderr.printf("�y�w���v�z\n")
  $stderr.printf("ck_edc.rb -? \t �w���v�\���i���̕\���j\n")
  $stderr.printf("�y�R�}���h�z\n")
  $stderr.printf(" [-�����C��] -���͕����R�[�h -�o�͕����R�[�h \n")
  $stderr.printf("    -f�F�����C���������s��\n")
  $stderr.printf("    �����R�[�h�i���́A�o�͂Ƃ��j\n")
  $stderr.printf("    -uni�F Unicode(UTF8), -win : Windows(CP932), -dos : MS-DOS(Shift-JIS),\n")
  $stderr.printf("    -mac : MacJP(old) , -euc : Unix(EUC-JP), -jis : JIS(ISO-2022-JP:7bit),\n")
  $stderr.printf("    -excel : Excel�p��BOM�t��Unicode(UTF8), �������Ȃǂ�BOM����UniCode(UTF8).\n")
  $stderr.printf("�y�g�p��z\n")
  $stderr.printf("ck_edc.rb -win -dos �w��t�@�C����\n")
  $stderr.printf("    Windows�R�[�h�̎w��t�@�C���̋@��ˑ��������AShift-JIS�R�[�h�Ń`�F�b�N���ĕ\��\n")
  $stderr.printf("ck_edc.rb -win -uni �w��t�@�C���� >���ʃt�@�C���� \n")
  $stderr.printf("    Windows�R�[�h�̎w��t�@�C���̋@��ˑ��������AUnicode(UTF8)�R�[�h�Ń`�F�b�N����\n")
  $stderr.printf("    ���ʃt�@�C��(.check)�ɕۑ�\n")
  $stderr.printf("ck_edc.rb -f -uni -excel �w��t�@�C���� >���ʃt�@�C���� \n")
  $stderr.printf("    Unicode(UTF8)�̎w��t�@�C���̋@��ˑ��������AEXCEL(BOM�t��UTF-8)�R�[�h�ŉ\�Ȍ���\n")
  $stderr.printf("    �����C�������ʃt�@�C��(_excel)�ɕۑ�\n")
  $stderr.printf("ck_edc.rb -f -uni -win �w��t�@�C���� >���ʃt�@�C���� \n")
  $stderr.printf("    Unicode(UTF8)�̎w��t�@�C���̋@��ˑ��������AWindows(cp932)�R�[�h�ŉ\�Ȍ���\n")
  $stderr.printf("    �����C�������ʃt�@�C��(_cp932)�ɕۑ�\n")
  $stderr.printf("�y���l�F�\���\�����͈̔́z\n")
  $stderr.printf("    JIS��Shift-JIS�̊����R�[�h��NEC PC9801��IBM PS/55�̊O�������������̂�CP932(Windows)�R�[�h�B\n")
  $stderr.printf("    JIS��Shift-JIS�̊����R�[�h��MacOS9�܂ł̊O�������������̂�MacJP�R�[�h(�VMac��Unicode(UTF8))�B\n")
  $stderr.printf("    JIS��Shift-JIS�̊����R�[�h�Ɋe��Unix�@�̊O�������������̂�EUC-JP�R�[�h(Linux��Unicode(UTF8)�B\n")
  $stderr.printf("    Unicode�͑S���E�̕�����\��������R�[�h�ŁA������Ȃ��C���^�[�l�b�g���y�ň�C�ɕW���ƂȂ����B\n")
  $stderr.printf("    Unicode�ɂ�UTF8(1-4Byte/����), UTF16(2Byte/�����E��������), UTF32(4Byte/����)������B\n")
  $stderr.printf("    Android/i-Phone�̃X�}�z��iPad���̃^�u���b�g�A�p�\�R���̃u���E�U���A������UTF8��W���Ƃ��Ă���B\n")  
  $stderr.printf("    �����_�ł�UTF8�����E�W���ŁAWindows�̃�������UTF8�B�A��Windows��EXCEL�ł�BOM�t��UTF8��CP932�A\n")
  $stderr.printf("    Windows�̃t�H���_����t�@�C������UTF32���g����B���AUTF16��UTF32�ɂ�Byte��������BOM���K�{�B\n")
  $stderr.printf("    �R�}���h�v�����v�g�ł́Achcp 932 ��CP932�R�[�h�Achch 65001 ��UTF8�R�[�h�Achcp 51932 ��EUC-JP\n")
  $stderr.printf("    �R�[�h�Achcp 1200 ��UTF16�R�[�h�ɕς��܂��Bchcp �����Ō��ݐݒ肳��Ă���R�[�h��\�����܂��B\n")
    
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
      $stderr.printf("<<%s>> ��%s�R�[�h�ŊJ���܂��B\n", file_name, enc_input)
    else
      $stderr.printf("<<%s>> �w��t�@�C�������݂��܂���A�t�@�C�������m�F���Ă��������B\n", file_name)
      exit
    end

row=0
fp.each_line do |line|
  $stdout.printf("�t�@�C�� %s �̕����R�[�h�E�G���R�[�f�B���O�� %s �ł��B\n", file_name, line.encoding)
  line.chomp!
  row+=1
  $stdout.printf("=== �s=%d \t ������=%d \t ������= %s ===\n", row, line.length, line)
  col=0
  $stdout.printf("�� \t ���� \t 16�i \t 10�i \t 2�i\n")
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

