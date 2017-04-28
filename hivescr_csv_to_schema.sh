#!/bin/bash

# -- VERSION -------------------------------------------------------------------

VERSION="hivescr_csv_to_schema v1.0"

# -- HELP ----------------------------------------------------------------------

HELP_CONTENT="
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


# -- ARGS ----------------------------------------------------------------------

ALL_ARGS="$0 $@"
option=""
counter=-1
CURRENT_DIR=`pwd`
for param in ${ALL_ARGS}
do
	counter=$((counter+1))

	# Ngedefine SCRIPT_FILE & SCRIPT_DIR
	if [ "$counter" = "0" ]; then
		SCRIPT_FILE=$param
		SCRIPT_DIR=`(cd \`dirname ${SCRIPT_FILE}\`; pwd)`
		echo SCRIPT_DIR
		# Jika file script ada link nya
		if [[ -L "${SCRIPT_FILE}" ]]
		then
			SCRIPT_FILE=`ls -la ${SCRIPT_FILE} | cut -d">" -f2`
			SCRIPT_DIR=`(cd \`dirname ${SCRIPT_FILE}\`; pwd)`
		fi
		SCRIPT_BASENAME=$(basename ${SCRIPT_FILE})
		SCRIPT_FILENAME=${SCRIPT_BASENAME%.*}
		continue
	fi

	# Menunjukkan versi dari script ini
	if [ "$param" = "-v" ] || [ "$param" = "--version" ]; then
		SHOW_VERSION="1"
		break
	fi

	# Menampilkan HELP
	if [ "$param" = "-h" ] || [ "$param" = "--help" ]; then
		SHOW_HELP="1"
		break
	fi

	# CSV Delimiter
	if [ "$param" = "-d" ] || [ "$param" = "--delimiter" ]; then
		option="OPTION_CSV_DELIMITER"
		continue
	fi
	if [ "$option" = "OPTION_CSV_DELIMITER" ]; then
		option=""
		CSV_DELIMITER=$param
		continue
	fi
	if [ "$param" = "-t" ] || [ "$param" = "--tab" ]; then
		CSV_DELIMITER="\t"
		continue
	fi

	# CSV yang tidak ada nama headernya
	if [ "$param" = "--no-header" ]; then
		CSV_NO_HEADER="1"
		continue
	fi

	# Separator Header
	if [ "$param" = "-s" ] || [ "$param" = "--separated-header" ]; then
                option="OPTION_SEPARATED_HEADER"
                continue
        fi
        if [ "$option" = "OPTION_SEPARATED_HEADER" ]; then
                option=""
                SEPARATED_HEADER_FILE=$param
                continue
        fi

	# File CSV tanpa header
        if [ "$param" = "--no-header" ]; then
                CSV_NO_HEADER="1"
                continue
        fi

	# Quote karakter
        if [ "$param" = "-q" ] || [ "$param" = "--quote-character" ]; then
                option="OPTION_QUOTE_CHARACTER"
                continue
        fi
        if [ "$option" = "OPTION_QUOTE_CHARACTER" ]; then
                option=""
                QUOTE_CHARACTER=$param
                continue
        fi

	# Parent call
        if [ "$param" = "--parent-call" ]; then
                PARENT_CALL="1"
                continue
        fi

	# Pilihan untuk skip
        if [ "$param" = "--create" ]; then
                continue
        fi
	if [ "$param" = "--db-name" ]; then
                option="OPTION_HIVE_DB_NAME"
                continue
        fi
        if [ "$option" = "OPTION_HIVE_DB_NAME" ]; then
                option=""
                continue
        fi
	if [ "$param" = "--table-name" ]; then
                option="OPTION_HIVE_TABLE_NAME"
                continue
        fi
        if [ "$option" = "OPTION_HIVE_TABLE_NAME" ]; then
                option=""
                continue
        fi
	if [ "$param" = "--table-prefix" ]; then
                option="OPTION_HIVE_TABLE_PREFIX"
                continue
        fi
        if [ "$option" = "OPTION_HIVE_TABLE_PREFIX" ]; then
                option=""
                continue
        fi
	if [ "$param" = "--table-suffix" ]; then
                option="OPTION_HIVE_TABLE_SUFFIX"
                continue
        fi
        if [ "$option" = "OPTION_HIVE_TABLE_SUFFIX" ]; then
                option=""
                continue
        fi
	if [ "$param" = "--parquet-create" ]; then
                continue
        fi
	if [ "$param" = "--parquet-db-name" ]; then
                option="OPTION_PARQUET_DB_NAME"
                continue
        fi
        if [ "$option" = "OPTION_PARQUET_DB_NAME" ]; then
                option=""
                continue
        fi
        if [ "$param" = "--parquet-table-name" ]; then
                option="OPTION_PARQUET_TABLE_NAME"
                continue
        fi
        if [ "$option" = "OPTION_PARQUET_TABLE_NAME" ]; then
                option=""
                continue
        fi
	if [ "$param" = "--parquet-table-prefix" ]; then
                option="OPTION_PARQUET_TABLE_PREFIX"
                continue
        fi
        if [ "$option" = "OPTION_PARQUET_TABLE_PREFIX" ]; then
                option=""
                continue
        fi
	if [ "$param" = "--parquet-table-suffix" ]; then
                option="OPTION_PARQUET_TABLE_SUFFIX"
                continue
        fi
        if [ "$option" = "OPTION_PARQUET_TABLE_SUFFIX" ]; then
                option=""
                continue
        fi
        if [ "$param" = "--hdfs-file-name" ]; then
                option="OPTION_HDFS_FILE_NAME"
                continue
        fi
        if [ "$option" = "OPTION_HDFS_FILE_NAME" ]; then
                option=""
                continue
        fi
	if [ "$param" = "--hdfs-file-prefix" ]; then
                option="OPTION_HDFS_FILE_PREFIX"
                continue
        fi
        if [ "$option" = "OPTION_HDFS_FILE_PREFIX" ]; then
                option=""
                continue
        fi
	if [ "$param" = "--hdfs-file-suffix" ]; then
                option="OPTION_HDFS_FILE_SUFFIX"
                continue
        fi
        if [ "$option" = "OPTION_HDFS_FILE_SUFFIX" ]; then
                option=""
                continue
        fi

	# Definisi CSV file
	if [ "${CSV_FILE}" = "" ]; then
		CSV_FILE=$param
		CSV_DIR=`(cd \`dirname ${CSV_FILE}\`; pwd)`
                CSV_BASENAME=$(basename ${CSV_FILE})
                CSV_FILENAME=${CSV_BASENAME%.*}
		#CSV_EXTENSION="${CSV_BASENAME##*.}"
		continue
	fi

	# Definisi Work directory
	if [ "${WORK_DIR}" = "" ]; then
		WORK_DIR=$param
		WORK_DIR=`(cd ${WORK_DIR}; pwd)`
		break
	fi
done

# -- VARIABLESS ----------------------------------------------------------------------

# Menampilkan versi script
if [ "${SHOW_VERSION}" = "1" ]; then
	echo -e "${VERSION}"
	exit 0
fi

# Menampilkan Script Help jika diminta
if [ "${SHOW_HELP}" = "1" ] || [ "$#" = "0" ]; then
	echo -e "${HELP_CONTENT}"
	exit 0
fi

# Watchdogs
if [ "${option}" = "OPTION_CSV_DELIMITER" ] && [ "${CSV_DELIMITER}" = "" ]; then
	echo "- Error: Delimiter hilang (note: untuk sebuah space delimiter, gunakan \"\\s\" daripada \" \") !"
	exit 1
fi
if [ "${option}" = "OPTION_SEPARATED_HEADER" ] && [ "${SEPARATED_HEADER_FILE}" = "" ]; then
	echo "- Error: Headernya tidak ditemukan !"
	exit 1
fi
if [ "${option}" = "OPTION_QUOTE_CHARACTER" ] && [ "${QUOTE_CHARACTER}" = "" ]; then
	echo "- Error: Quote karakter tidak ditemukan !"
	exit 1
fi

# Check jika argument file CSV tidak ditemukan atau file tidak ditemukan 
if [ "${CSV_FILE}" = "" ]; then
	echo "- Error: File CSV tidak ditemukan ! Coba \"-h\" or \"--help\" untuk bisa digunakan."
	exit 1
fi
if [ ! -f ${CSV_FILE} ]; then
	echo "- Error: File \"${CSV_FILE}\" tidak ditemukan !"
	exit 1
fi

# Jika argument work directory tidak ditemukan, maka menggunakan current directory
if [ "${WORK_DIR}" = "" ]; then
	WORK_DIR=${CURRENT_DIR}
fi

# Jika work directory adalah sama dengan directory CSV, Maka buat sub-directory
# yang akan menjadi work directory yang baru
if [ "${WORK_DIR}" = "${CSV_DIR}" ]; then
	if [ ! -d "${WORK_DIR}/${CSV_FILENAME}" ]; then
		mkdir "${WORK_DIR}/${CSV_FILENAME}"
	fi
        WORK_DIR=${WORK_DIR}/${CSV_FILENAME}
fi

# CSV short file
CSV_SHORT_FILE=${WORK_DIR}/${CSV_FILENAME}.short

# schema file
SCHEMA_FILE=${WORK_DIR}/${CSV_FILENAME}.schema

# vi command file
VI_COMMANDS_FILE=${WORK_DIR}/${CSV_FILENAME}.vi

# vi commands untuk mengubah file SQL-DDL yang digenerate oleh csvsql menjadi file schema
VI_COMMANDS="dd
G
dd
G\$a,\e
:%s/\t//g
:%s/\"//g
:%s/, /,/g
:g/^CHECK (/d
:%s/ NOT NULL,/,/g
:%s/([0-9]*)//g
:%s/ VARCHAR,/-string,/g
:%s/ STRING,/-string,/g
:%s/ DATETIME,/-string,/g
:%s/ DATE,/-string,/g
:%s/ TIMESTAMP,/-string,/g
:%s/ INTEGER,/-int,/g
:%s/ INT,/-int,/g
:%s/ TINYINT,/-int,/g
:%s/ SMALLINT,/-int,/g
:%s/ BIGINT,/-bigint,/g
:%s/ DECIMAL,/-decimal,/g
:%s/ DOUBLE,/-double,/g
:%s/ FLOAT,/-float,/g
:%s/ BOOLEAN,/-boolean,/g
:%s/ BINARY,/-binary,/g
:%s/ /_/g
:%s/-string,/ string,/g
:%s/-int,/ int,/g
:%s/-bigint,/ bigint,/g
:%s/-decimal,/ decimal,/g
:%s/-double,/ double,/g
:%s/-float,/ float,/g
:%s/-boolean,/ boolean,/g
:%s/-binary,/ binary,/g
:%s/^_/x_/g
G\$x
:wq
"

# -- PROGRAM ----------------------------------------------------------------------

# Membuat csv short file yang digunakan oleh command csvsql
head -10000 "${CSV_FILE}" > "${CSV_SHORT_FILE}"

# Jika separator header filenya ada maka concat menggunakan csv short file
if [ ! "${SEPARATED_HEADER_FILE}" = "" ]; then
	cp "${SEPARATED_HEADER_FILE}" "${CSV_SHORT_FILE}~"
	cat "${CSV_SHORT_FILE}" >> "${CSV_SHORT_FILE}~"
	mv "${CSV_SHORT_FILE}~" "${CSV_SHORT_FILE}"
	CSV_NO_HEADER="0"
fi

# Cari delimiter jika tidak ditemukan menggunakan python
if [ "${CSV_DELIMITER}" = "" ]; then
    TWO_FIRST_LINES_FILE=${WORK_DIR}/${CSV_FILENAME}.2FirstLines
	if [ ! "${SEPARATED_HEADER_FILE}" = "" ]; then
		cp "${SEPARATED_HEADER_FILE}" "${TWO_FIRST_LINES_FILE}"
		head -1 "${CSV_FILE}" | cat >> "${TWO_FIRST_LINES_FILE}"
	else
		head -2 "${CSV_FILE}" > "${TWO_FIRST_LINES_FILE}"
	fi

	STRING_1=`head -1 "${TWO_FIRST_LINES_FILE}"`
	STRING_2=`tail -n +2 "${TWO_FIRST_LINES_FILE}"`
	rm -rf "${TWO_FIRST_LINES_FILE}"
	CSV_DELIMITER=`python "${SCRIPT_DIR}/hivescr_search_delimiter.py" "${STRING_1}" "${STRING_2}" "${QUOTE_CHARACTER}"`
	if [ "${CSV_DELIMITER}" = "NO_DELIMITER" ]; then
			echo "- Error: Delimiter tidak ditemukan !"
	echo "Mungkin banyaknya delimiter berbeda dengan dua baris pertama!"
	echo "Atau mungkin kamu harus check quote karakter (-q option) !"
		exit 1
	fi
fi

# Spesifikasi pilihan delimiter untuk command the csvsql
CSVSQL_OPTS=
if [ "${CSV_DELIMITER}" = "\t" ]; then
	CSVSQL_OPTS="${CSVSQL_OPTS}-t"
elif [ "${CSV_DELIMITER}" = "\s" ]; then
	CSVSQL_OPTS="${CSVSQL_OPTS}"
else
	CSVSQL_OPTS="${CSVSQL_OPTS}-d ${CSV_DELIMITER}"
fi

# Spesifikasi ISO8859 dan pilihan no-constraints
CSVSQL_OPTS="${CSVSQL_OPTS} -b -e ISO8859 --no-constraints"

# Set pilihan header csvsql header jika input file csv tidak memiliki header
if [ "${CSV_NO_HEADER}" = "1" ]; then
	CSVSQL_OPTS="${CSVSQL_OPTS} --no-header-row"
fi

# Membuat DDL SQL dengan csvsql dari CSV file menggunakan  
csvsql ${CSVSQL_OPTS} "${CSV_SHORT_FILE}" > "${SCHEMA_FILE}"

# Membuat file ci yang mengandung command vi
rm -rf "${VI_COMMANDS_FILE}"
touch "${VI_COMMANDS_FILE}"
echo -e "${VI_COMMANDS}" > "${VI_COMMANDS_FILE}"

# Hapus file DDL SQL dengang menggunakan command vi untuk membuat file schema
# yang nanti akan digunakan untuk membuat statement CREATE TABLE di Hive
vi "${SCHEMA_FILE}" < "${VI_COMMANDS_FILE}" 2> /dev/null
rm -rf "${VI_COMMANDS_FILE}"

# Jika script sudah dipanggil oleh parent script
if [ "${PARENT_CALL}" = "1" ]; then
	rm -rf "${CSV_SHORT_FILE}"
fi

