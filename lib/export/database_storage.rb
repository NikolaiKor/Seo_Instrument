require_relative 'abstract_storage'
require 'pg'

class Database_storage < AbstractStorage
  TYPE = 'pg_database'

  def add_report

  end

  def all_reports

  end

  def find_report

  end

  def connector(querry)
    #host port options tty dbname user password
    conn = PG.connect(host: 'localhost', port: 5432, dbname: 'seo_database', user: 'seo', password: 'seopass')
    conn.exec(querry)
  end
end