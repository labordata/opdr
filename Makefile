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


odpr.db : initialize.sql $(patsubst %,%.csv,$(TABLES))
	sqlite3 $@ < $<
	for table in $(TABLES); do \
           sqlite3 $@ -csv -bail ".import $$table.csv $$table"  ; \
        done

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
