package "wkhtmltopdf" do
  action :purge
end

package "libfontconfig1"
package "xvfb"
package "libxrender-dev"

wkhtml2pdf_file = "wkhtmltopdf-0.11.0_rc1-static-amd64.tar.bz2"

# log "Downloading #{wkhtml2pdf_file}"
remote_file "/usr/bin/#{wkhtml2pdf_file}" do
    source "http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.11.0_rc1-static-amd64.tar.bz2"
    not_if do
      File.exists?("/usr/bin/#{wkhtml2pdf_file}")
    end
end

execute "cd /usr/bin && tar xvjf /usr/bin/#{wkhtml2pdf_file}" do
    not_if do
      File.exists?("/usr/bin/wkhtmltopdf-amd64")
    end
end

execute "cd /usr/bin && cp wkhtmltopdf-amd64 wkhtmltopdf" do
    not_if do
      File.exists?("/usr/bin/wkhtmltopdf")
    end
end

#execute "rm /usr/bin/#{wkhtml2pdf_file}"
# log "Downloading #{wkhtml2pdf_file} :: Done"
