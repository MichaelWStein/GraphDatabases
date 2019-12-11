//Only use if database needs to be cleaned:
MATCH (n) DETACH DELETE n;

//Below does not check for existence - this creation works only on an empty database, otherwise double nodes / relationships may be deleted.
CREATE (Walkers:Program {name:'Walkers', full_name:'Walkers.ipynb', language:'Python_3', used_for:'KHP Datathon', creator:'MS', date:('2019-11-26'), comment:'Creates dataframe for each Walker with participation 2010-2019'})

CREATE 
    (Walkers_csv:Data {name:'Walker', full_name:'Walkers.csv', format:'csv', used_for:'KHP Datathon', creator:'KHP', date:('2019-11-26'), comment:'Walkers from 2010 - 2019', status:'deleted'}),
    (Walkers)-[:LOADS]->(Walkers_csv)

CREATE 
    (walker_df:Data {name:'walker_df', full_name:'walker_df.csv', format:'csv', used_for:'KHP Datathon', creator:'MS', date:('2019-11-26'), comment:'data transfer for easier programming', status:'deleted'})
CREATE    
    (Walkers)-[:WRITES]->(walker_df)
CREATE
    (WalkerAnalysis: Program {name:'WalkerAnalysis', full_name:'WalkerAnalysis.ipynb', language:'Python_3', used_for:'KHP Datathon', creator:'MS', date:('2019-11-26'), comment:'Analysis of Walker data'})
CREATE
    (walker_complete:Data {name:'walker_analysed', full_name:'WalkersComplete.csv', format:'csv', used_for:'KHP Datathon', creator:'MS', date:('2019-11-26'), comment:'Walkers data sorted and analysed', status:'deleted'})
CREATE
    (WalkerAnalysis)-[:WRITES]->(walker_complete)
CREATE
    (WalkerAnalysis)-[:LOADS]->(walker_df);

CREATE (Donors:Program {name:'Donors', full_name:'donorsAn.ipynb', language:'Python_3', used_for:'KHP Datathon', creator:'MS', date:('2019-12-11'), comment:'Creates dataframe for donors, includes cleaning and basic analysis'})

CREATE 
    (Donors_csv:Data {name:'Donors Data', full_name:'Donors.csv', format:'csv', used_for:'KHP Datathon', creator:'KHP', date:('2019-11-26'), comment:'Donors from 2010 - 2019', status:'deleted'}),
    (Donors)-[:LOADS]->(Donors_csv);

CREATE 
    (donors_df:Data {name:'donors', full_name:'Donors.csv', format:'csv', used_for:'KHP Datathon', creator:'MS', date:('2019-11-26'), comment:'data transfer for analysis', status:'deleted'});
CREATE    
    (Gift_Total:Data {name:'Gift_Total', full_name:'Gift_Total.csv', format:'csv', used_for:'KHP Datathon', creator:'MS', date:('2019-11-26'), comment:'Total donations per year', status:'deleted'});

MATCH (a:Program), (d:Data)
WHERE a.name = 'Donors' AND (d.name = 'donors' OR d.name = 'Gift_Total')
CREATE (a)-[:WRITES]->(d)
RETURN a, d;    

CREATE (Donors_Proc:Program {name:'Donors_Proc', full_name:'donors_furth_proc.ipynb', language:'Python_3', used_for:'KHP Datathon', creator:'MS', date:('2019-12-11'), comment:'Further cleaning of donors dataframe, creates df with donors and their donations for each year'})

CREATE 
    (Donors_Complete:Data {name:'Donors_Complete', full_name:'DonorsComplete.csv', format:'csv', used_for:'KHP Datathon', creator:'KHP', date:('2019-12-11'), comment:'Donors from 2010 - 2019', status:'deleted'}),
    (Donors_Proc)-[:WRITES]->(Donors_Complete);    

MATCH (a:Program), (d:Data)
WHERE a.name = 'Donors_Proc' AND d.name = 'donors'
CREATE (a)-[:LOADS]->(d)
RETURN a, d; 

CREATE 
    (Donor_Anal:Program {name:'Donor-Anal', full_name:'donor_anal.ipynb', language:'Python_3', used_for:'KHP Datathon', creator:'MS', date:('2019-12-11'), comment:'some analysis on donorrs dataframe, saving with changed column names.'})

CREATE 
    (Donors_Analysed:Data {name:'Donors_Analysed', full_name:'donors_analysed.csv', format:'csv', used_for:'KHP Datathon', creator:'KHP', date:('2019-12-11'), comment:'Donors 2013-2019, analysed ', status:'deleted'});

MATCH (a:Program), (d:Data)
WHERE a.name = 'Donor-Anal' AND d.name = 'Donors-Complete'
CREATE (a)-[:LOADS]->(d)
RETURN a, d; 

MATCH (a:Program), (d:Data)
WHERE a.name = 'Donor-Anal' AND d.name = 'Donors_Analysed'
CREATE (a)-[:WRITES]->(d)
RETURN a, d; 

//Cleaning Up - deleting a node based on id
MATCH(n) where id(n)=31
DETACH DELETE n;

CREATE 
    (Gift_Anal:Program {name:'Gift_Anal', full_name:'GiftAnalysis.ipynb', language:'Python_3', used_for:'KHP Datathon', creator:'MS', date:('2019-12-11'), comment:'Enhances Walker info by adding donors and donations for each walker (2019 only).'})
CREATE 
    (Walkers_2019:Data {name:'Walkers_2019', full_name:'Walkers_2019.csv', format:'csv', used_for:'KHP Datathon', creator:'KHP', date:('2019-12-11'), comment:'Walkers, with donors and donations for 2019 only', status:'deleted'}),
    (Gift_Anal)-[:WRITES]->(Walkers_2019); 

CREATE 
    (Gifts:Data {name:'Gift_Total', full_name:'clean_donations_linked_to_walkers.csv', format:'csv', used_for:'KHP Datathon', creator:'KHP', date:('2019-12-11'), comment:'Link of donation Ids to walkers.', status:'deleted'});


MATCH (a:Program), (d:Data)
WHERE a.name = 'Gift_Anal' AND (d.name = 'walker_analysed' OR d.name = 'Gift_Total' OR d.name = 'donors')
CREATE (a)-[:LOADS]->(d)
RETURN a, d; 
