# hive-csv-to-hive
Import CSV file ke Hive menjadi sebuah table baru

cara penggunaan: sh hivescr_csv_to_schema.sh [CSV_FILE] {WORK_DIR}

Mengenerate schema database dari file CSV yang mengandung nama kolom dan tipe 
	data dari kolom tersebut

arg1 wajib:
  CSV_FILE	Nama file csv
  WORK_DIR	Nama directoy dimana file schema akan di generated.
		Jika tidak ditentukan (optional) maka file schema akan di generated
		di folder yang sama dimana file CSV berada, nama file schema tersebut
		sama dengan nama file CSV namun mempunyai ekstensi '.schema'

arg2 tambahan:
  -v, --version : Menampilkan versi dari script ini	
  -h, --help	: Menampilkan pesan Help ini
  -d DELIMITER, --delimiter DELIMITER
		: 	Mengidentifikasi delimiter yang ada di file CSV.
			Jika tidak ada args -t atau --tab, maka delimiter akan mencari diantara:
			{\",\" \"\\\t\" \";\" \"|\" \"\\\s\"}.
  -t, --tab	
		: 	Mengidentifikasi delimiter yang ada di file CSV.
			Overrides -d and --delimiter.
			Jika tidak ada args -d atau --delimiter, maka delimiter akan mencari diantara:
			{\",\" \"\\\t\" \";\" \"|\" \"\\\s\"}.
  --no-header	
		:	Jika args ini ada, mengindikasikan bahwa file CSV tidak memiliki header
			Kolomnya akan bernama 'column1', 'column2', dan seterusnya
  -s SEPARATED_HEADER, --separated-header SEPARATED_HEADER
		:	Menspesifikasi separator di file CSV yang mengandung header, delimiternya
			harus sama dengan delimiter di file CSV.
			Overrides --no-header.
  -q QUOTE_CHARACTER, --quote-character QUOTE_CHARACTER 
		:	karakter quote yang ada di header CSV
"
