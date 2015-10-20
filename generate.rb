require 'fileutils'
require 'erb'

FileUtils.mkdir_p('build')
template_html = DATA.read.dup

Dir["*.SHA256SUM.txt"].each do |filename|
  _, language, version = filename.match(/(.*)_buildpack-cached-v(.*).zip.SHA256SUM.txt/).to_a
  puts "language = #{language}, version = #{version}"

  # generate a language/version/index.html
  dirname = "build/#{language}/#{version}"
  FileUtils.mkdir_p(dirname)

  buildpack_filename = "#{language}_buildpack-cached-v#{version}.zip"
  sha_filename       = filename
  github_filename    = "https://github.com/cloudfoundry/#{language}-buildpack/releases/download/v#{version}/#{buildpack_filename}"

  FileUtils.cp(filename, dirname)
  File.write("#{dirname}/index.html", ERB.new(template_html).result(binding))
end

__END__

<html>
<head>
  <title>Index of /<%= language %>/<%= version %>/</title>
</head>
<body bgcolor="white">
<h1>Index of /<%= language %>/<%= version %>/</h1>
<hr>
<pre>
<a href="../">../</a>
<a href="<%= sha_filename %>"><%= sha_filename %></a><%= " " * (80 - sha_filename.length) %><%= sprintf("%15s%15s", '2008-01-01', '12312312') %>
<a href="<%= github_filename %>"><%= buildpack_filename %></a><%= " " * (80 - buildpack_filename.length) %><%= sprintf("%15s%15s", '2008-01-01', '12312312') %>
</body>
</html>
