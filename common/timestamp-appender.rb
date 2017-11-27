append_timestamp = ENV['APPEND_TIMESTAMP'] || 'false'
if append_timestamp != 'true' && append_timestamp != 'false'
  puts 'APPEND_TIMESTAMP must be \'true\' or \'false\'.'
  abort
end
if append_timestamp == 'true'
  def $stdout.write string
    log_datas=string
    if log_datas.gsub(/\r?\n/, "") != ''
      log_datas=::Time.now.strftime("%d/%m/%Y %T")+" "+log_datas.gsub(/\r\n/, "\n")
    end
    super log_datas
  end
  def $stderr.write string
    log_datas=string
    if log_datas.gsub(/\r?\n/, "") != ''
      log_datas=::Time.now.strftime("%d/%m/%Y %T")+" "+log_datas.gsub(/\r\n/, "\n")
    end
    super log_datas
  end
end
