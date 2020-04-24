module GeneratorHelpers
  def write_file(file_name, contents)
    file_path = File.expand_path(file_name, destination_root)

    FileUtils.mkdir_p(File.dirname(file_path))
    File.write(file_path, contents)
  end
end
