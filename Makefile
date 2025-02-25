.DELETE_ON_ERROR:
SHELL=bash -e -o pipefail

TABLES=lm_data ar_assets_accts_rcvbl ar_assets_fixed			\
       ar_assets_investments ar_assets_loans_rcvbl ar_assets_other	\
       ar_assets_total ar_disbursements_benefits			\
       ar_disbursements_emp_off ar_disbursements_genrl			\
       ar_disbursements_inv_purchases ar_disbursements_total		\
       ar_erds_codes ar_liabilities_accts_paybl				\
       ar_liabilities_loans_paybl ar_liabilities_other			\
       ar_liabilities_total ar_membership ar_payer_payee		\
       ar_rates_dues_fees ar_receipts_inv_fa_sales ar_receipts_other	\
       ar_receipts_total

YEARS=$(shell python scripts/years.py)

opdr.db : initialize.sql $(patsubst %,%.csv,$(TABLES))
	sqlite3 $@ < $<
	for table in $(TABLES); do \
            sqlite3 $@ -csv -bail ".import $$table.csv $$table"  ; \
        done
	sqlite3 $@ < scripts/trimify.sql > table_trim.sql && \
            sqlite3 $@ < table_trim.sql > trim.sql && \
            sqlite3 $@ < trim.sql
	sqlite3 $@ < scripts/nullify.sql > table_nullify.sql && \
            sqlite3 $@ < table_nullify.sql > null.sql && \
            sqlite3 $@ < null.sql
	sqlite3 $@ < scripts/next_election.sql
	sqlite3 $@ < scripts/uniquify_erds.sql
	sqlite-utils transform $@ ar_erds_codes \
            --pk=code \
            --rename code_name name
	sqlite-utils transform $@ ar_payer_payee \
            --pk=payer_payee_id \
            --add-foreign-key payer_payee_type ar_erds_codes code \
            --add-foreign-key rcpt_disb_type ar_erds_codes code
	sqlite-utils transform $@ ar_disbursements_genrl \
            --add-foreign-key payer_payee_id ar_payer_payee payer_payee_id
	sqlite-utils transform $@ ar_receipts_other \
            --add-foreign-key payer_payee_id ar_payer_payee payer_payee_id \
            --add-foreign-key receipt_type ar_erds_codes code
	sqlite-utils transform $@ ar_assets_accts_rcvbl \
            --add-foreign-key acct_type ar_erds_codes code
	sqlite-utils transform $@ ar_assets_fixed \
            --add-foreign-key asset_type ar_erds_codes code
	sqlite-utils transform $@ ar_assets_investments \
            --add-foreign-key inv_type ar_erds_codes code
	sqlite-utils transform $@ ar_assets_loans_rcvbl \
            --add-foreign-key laon_type ar_erds_codes code
	sqlite-utils transform $@ ar_assets_loans_rcvbl \
            --add-foreign-key loan_type ar_erds_codes code
	sqlite-utils transform $@ ar_disbursements_emp_off \
            --add-foreign-key emp_off_type ar_erds_codes code
	sqlite-utils transform $@ ar_disbursements_genrl \
            --add-foreign-key disbursement_type ar_erds_codes code
	sqlite-utils transform $@ ar_disbursements_inv_purchases \
            --drop=inv_type
	sqlite-utils transform $@ ar_liabilities_accts_paybl \
            --add-foreign-key acct_type ar_erds_codes code
	sqlite-utils transform $@ ar_membership \
            --add-foreign-key membership_type ar_erds_codes code
	sqlite-utils transform $@ ar_rates_dues_fees \
            --add-foreign-key rate_type ar_erds_codes code
	sqlite-utils transform $@ ar_receipts_inv_fa_sales \
            --drop=inv_type
	sqlite-utils transform $@ lm_data \
            --add-foreign-key fye ar_erds_codes code \
            --add-foreign-key address_type ar_erds_codes code

.INTERMEDIATE : initialize.sql
initialize.sql : $(patsubst %,%.sql,$(TABLES))
	cat $^ > $@

.INTERMEDIATE : $(patsubst %,%.sql,$(TABLES))
%.sql :	%_meta.txt
	python scripts/table_description_to_sql.py $< > $@

%.csv : $(patsubst %,\%_data_%.txt,$(YEARS))
	cat $^ | python scripts/to_csv.py > $@

ar_assets_accts_rcvbl_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_assets_fixed_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_assets_investments_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_assets_loans_rcvbl_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_assets_other_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_assets_total_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_disbursements_benefits_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_disbursements_emp_off_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_disbursements_genrl_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_disbursements_inv_purchases_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_disbursements_total_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_erds_codes_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_liabilities_accts_paybl_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_liabilities_loans_paybl_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_liabilities_other_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_liabilities_total_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_membership_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_payer_payee_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_rates_dues_fees_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_receipts_inv_fa_sales_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_receipts_other_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

ar_receipts_total_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

lm_data_data_%.txt : %.zip
	unzip -p $< $@ | tail -n +2 > $@

%_meta.txt : 2000.zip
	unzip -p $< $@ > $@

%.zip :
	python scripts/yearly_filing.py $* $@ 
