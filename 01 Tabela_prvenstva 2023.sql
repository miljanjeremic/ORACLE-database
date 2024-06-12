
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "TABELA_PRVENSTVA2023" ("NAZIV", "BODOVI", "GOL_DAT", "GOL_PRIM", "GOL_RAZL", "BROJ_UTAKMICA") AS 
  SELECT Reprezentacija.naziv, Sum(CASE WHEN Reprezentacija.naziv = Utakmica.domacin THEN 
                                        CASE WHEN Utakmica.datih > Utakmica.primljenih THEN 3
                                             WHEN Utakmica.datih = Utakmica.primljenih THEN 1
                                             ELSE 0
                                        END
                                        ELSE
                                        CASE WHEN Reprezentacija.naziv = Utakmica.gost THEN 
                                          CASE WHEN Utakmica.primljenih > Utakmica.datih THEN 3
				                             WHEN Utakmica.primljenih = Utakmica.datih THEN 1
                                             ELSE 0
                                           END
                                        END
				                        --ELSE 0
                                    END) AS Bodovi,
SUM(CASE WHEN Reprezentacija.naziv = Utakmica.domacin THEN Utakmica.datih ELSE Utakmica.primljenih END) AS Gol_Dat,
SUM(CASE WHEN Reprezentacija.naziv = Utakmica.domacin THEN Utakmica.primljenih ELSE Utakmica.datih END) AS Gol_Prim,
SUM(CASE WHEN Reprezentacija.naziv = Utakmica.domacin THEN Utakmica.datih ELSE Utakmica.primljenih END) -
SUM(CASE WHEN Reprezentacija.naziv = Utakmica.domacin THEN Utakmica.primljenih ELSE Utakmica.datih END) AS Gol_Razl,
                             -- Sum(CASE 
			                      --WHEN Reprezentacija.naziv = Utakmica.domacin THEN UČESTVUJE.datih
                                  --WHEN Reprezentacija.naziv = Utakmica.gost THEN UČESTVUJE.primljenih
                                 --ELSE 0
                                 --END) AS Gol_Dat,
			                  --Sum(CASE 
			                      --WHEN Reprezentacija.naziv = Utakmica.domacin THEN UČESTVUJE.primljenih
                                  --WHEN Reprezentacija.naziv = Utakmica.gost THEN UČESTVUJE.datih
                                 --ELSE 0
                                 --END) AS Gol_Prim,
                              --Sum(CASE 
                                 -- WHEN Reprezentacija.naziv = Utakmica.domacin THEN UČESTVUJE.datih - UČESTVUJE.primljenih
                                  --WHEN Reprezentacija.naziv = Utakmica.gost THEN UČESTVUJE.datih - UČESTVUJE.primljenih
                                 --ELSE 0
                                 --END) AS Gol_Razl, 
                              COUNT(DISTINCT(Utakmica.idutakmice)) AS Broj_utakmica
FROM Reprezentacija LEFT JOIN Utakmica ON Reprezentacija.naziv = Utakmica.domacin OR Reprezentacija.naziv = Utakmica.gost
WHERE Utakmica.nazivgrupe = 'A'
GROUP BY Reprezentacija.skrac, Reprezentacija.naziv
ORDER BY Bodovi DESC, Reprezentacija.naziv DESC;