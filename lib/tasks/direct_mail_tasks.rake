require 'redd'

namespace :office do

  desc "20221118 - churn envelopes"
  task :churn_20231118 => :environment do
    props = {
      from: {
        name: 'Wasya Co',
        address_2: '201 W 5th St 11th Fl',
        address_3: 'Austin, TX 78701',
      },
      tos: [],
    }
    ## 0           1          2             3        4     5      6
    ## first name, last name, company name, address, city, state, zipcode
    inns = CSV.read('data/20231118_402_marketing.csv', headers: true).each do |row|
      props[:tos].push({
        name: "#{row[0]} #{row[1]}, #{row[2]}",
        address_2: row[3],
        address_3: "#{row[4]}, #{row[5]} #{row[6]}",
      })
    end

    pdf = Office::DirectmailEnvelope.list_to_envelopes props
    path = '/tmp/envelopes.pdf'
    # File.write(path, pdf)
    pdf.render_file path
    `mv /tmp/envelopes.pdf ~/Desktop/`
    puts 'ok'
  end

end



