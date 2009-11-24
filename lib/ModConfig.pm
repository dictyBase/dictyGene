=head1 NAME

B<ModConfig> - Module to load site wide configuration


=head1 SYNOPSIS

use ModConfig;

my $config = ModConfig->load();

=head2 Extracting simple values

 print $config->value("WEB_HOST"), "\t", $config->value("WEB_ROOT");

==head2 Extracting nested values

 my $org = $config->obj("ORGANISMS")->obj("ORGANISM");

if ($org->exists("dicty")) {
  print $org->value("TAXON_ID")

}


=head1 DESCRIPTION

For more look at the documentation of B<Config::General>

=cut


package ModConfig;
use strict;
use Config::General;
my $config = {
            'TESTS' => {
                       'NON_CORE' => {
                                     'NAME' => [
                                               'Apollo',
                                               'Annotation',
                                               'Blast_loader',
                                               'Colleague',
                                               'Chado',
                                               'CDNA_CLONE',
                                               'Clustalw',
                                               'DATABANK_ENTRY',
                                               'Evidence',
                                               'Environment',
                                               'Experiment',
                                               'Genotype',
                                               'Genbank_mrna_record',
                                               'Genbank_record',
                                               'Genbank_writer',
                                               'Gene_product',
                                               'GO',
                                               'InterproResult',
                                               'Link',
                                               'Paragraph',
                                               'Phenotype',
                                               'Pathologic_writer',
                                               'Phenotype_character',
                                               'Strain',
                                               'bioperl_pubmed',
                                               'domain_das_adp',
                                               'domain_itr_factory',
                                               'domain_src_factory',
                                               'pubmed_finder',
                                               'run_domain_tests',
                                               'run_iterator_tests',
                                               'test_seq_insert'
                                             ]
                                   },
                       'UI_NONCORE' => {
                                       'NAME' => 'run_tabview_tests'
                                     },
                       'UI_CORE' => {
                                    'NAME' => 'run_tabview_tests_core'
                                  },
                       'CORE' => {
                                 'NAME' => [
                                           'Oracleseq',
                                           'Feature',
                                           'iterator',
                                           'protein_info',
                                           'cv',
                                           'CONTIG',
                                           'CONTIG_REFERENCE',
                                           'EST',
                                           'GAP',
                                           'GENE',
                                           'MRNA',
                                           'NCRNA',
                                           'POLYPEPTIDE',
                                           'PROMOTER',
                                           'PSEDOGENE',
                                           'Segment',
                                           'TRNA',
                                           'Reference_feature',
                                           'run_unit_tests'
                                         ]
                               }
                     },
            'WEB_HOST' => '192.168.60.50',
            'NLS_LANG' => 'AMERICAN',
            'UID' => 'DPUR_CGM_DDB/DPUR_CGM_DDB@DICTYBASE',
            'ORACLE_HOME' => '/usr/local/instantclient_10_2',
            'CHADO_PW' => 'DPUR_CHADO',
            'SITE_NAME' => 'dictyBaseDP',
            'CHADO_UID' => 'DPUR_CHADO/DPUR_CHADO@DICTYBASE',
            'BLAST_PORT' => '80',
            'WEB_ROOT' => 'www_dictybase',
            'BLAST_SERVER_USER' => 'ubuntu',
            'ORGANISMS' => {
                           'ORGANISM' => {
                                         'physarum' => {
                                                       'TAXON_ID' => '5791',
                                                       'SPECIES' => 'polycephalum',
                                                       'GENUS' => 'Physarum',
                                                       'IDENTIFIER_PREFIX' => 'PPO'
                                                     },
                                         'dicty' => {
                                                    'TAXON_ID' => '44689',
                                                    'SITE_URL' => 'http://dictybase.org',
                                                    'SPECIES' => 'discoideum',
                                                    'GENUS' => 'Dictyostelium',
                                                    'IDENTIFIER_PREFIX' => 'DDB'
                                                  },
                                         'dpur' => {
                                                   'TAXON_ID' => '5786',
                                                   'REFERENCE_FEATURE_BLASTDB' => 'dpur_supercontig_masked',
                                                   'SPECIES' => 'purpureum',
                                                   'GENUS' => 'Dictyostelium',
                                                   'IDENTIFIER_PREFIX' => 'DPU'
                                                 }
                                       }
                         },
            'SWISH_ROOT' => '/usr/local/dicty/util/SWISH-E',
            'WEB_LIB_ROOT' => '/usr/local/dicty/www_dictybase/db/lib',
            'QUICKSEARCH_CLASSES' => '
  dicty::UI::Search::Gene
  dicty::UI::Search::Gene_product
  dicty::UI::Search::Gene_description
  dicty::UI::Search::GO
  dicty::UI::Search::EST
  dicty::UI::Search::Colleague
  dicty::UI::Search::Author
  dicty::UI::Search::Primary_id
  dicty::UI::Search::Dbxref
	',
            'TNS_ADMIN' => '/usr/local/instantclient_10_2',
            'USER' => 'DPUR_CGM_DDB',
            'LISTSERVE_EMAIL' => 'e-just@northwestern.edu',
            'PERL_BINARY' => '/usr/bin/perl',
            'CHADO_USER' => 'DPUR_CHADO',
            'WEB_URL_ROOT' => '192.168.60.50',
            'WEB_WWW_ROOT' => '/usr/local/dicty/www_dictybase',
            'PATH' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/X11R6/bin:/usr/local/instantclient_10_2/bin/',
            'PERL5LIB' => '/usr/local/dicty/lib',
            'BLAST_SERVER_PW' => 'dicty123',
            'TIME_STYLE' => 'locale',
            'APACHE_MODULES' => {
                                'MODULE' => [
                                            'headers',
                                            'expires',
                                            'cache',
                                            'deflate',
                                            'rewrite',
                                            'include',
                                            'apreq'
                                          ]
                              },
            'DBUID' => 'DPUR_CGM_DDB/DPUR_CGM_DDB@DICTYBASE',
            'ENTREZ_SEARCH_STRING' => '
    txid44689[Organism:noexp] and (biomol_genomic[prop] OR biomol_mrna[PROP]) NOT srcdb_refseq[PROP] NOT gbdiv_sts[PROP] NOT gbdiv_est[PROP] NOT CHROMOSOME 2 [TITL] NOT AB000109"
		',
            'DATABASE' => 'DICTYBASE',
            'PASSWORD' => 'DPUR_CGM_DDB',
            'UNIX_UTILS_PATH' => '/bin',
            'LD_LIBRARY_PATH' => '/usr/local/instantclient_10_2',
            'BIN_DIR' => '/usr/local/dicty/bin',
            'WEB_DB_ROOT' => '/usr/local/dicty/www_dictybase/db',
            'BLAST_SERVER' => '192.168.60.30',
            'PORT' => '80',
            'APACHE_LOGS_DIR' => '/var/log/apache2',
            'SITE_ADMIN_EMAIL' => 'siddhartha-basu@northwestern.edu',
            'DBUSER' => 'DPUR_CGM_DDB',
            'MART_USER' => 'DPUR_MART',
            'MART_UID' => 'DPUR_MART/MARTRCTDWAK@DICTYBASE',
            'DATA_DIR' => '/usr/local/dicty/data',
            'MART_PW' => 'MARTRCTDWAK',
            'DICTY_DIR_ROOT' => '/usr/local/dicty',
            'ORACLE_ROOT' => '/usr/local/instantclient_10_2',
            'MAIL_SERVER' => 'hecky.it.northwestern.edu',
            'REPORT' => {},
            'VERSION' => 'test',
            'APACHE_CONFIG_DIR' => '/etc/apache2'
          };
sub load {
my $conf = Config::General->new(-ConfigHash => $config,  -ExtendedAccess	=> 1); return $conf;
}

1;
