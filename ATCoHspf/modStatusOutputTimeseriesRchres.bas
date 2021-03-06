Attribute VB_Name = "modStatusOutputTimeseriesRchres"
Option Explicit
'Copyright 2002 AQUA TERRA Consultants - Royalty-free use permitted under open source license

Public Sub UpdateOutputTimeseriesRchres(O As HspfOperation, TimserStatus As HspfStatus)
  Dim ltable As HspfTable
  Dim i&, j&, AUX2FG&, AUX3FG&
  Dim nExits&, Odfvfg&(5), Odgtfg&(5), nCons&, nGqual&
  
  If O.TableExists("ACTIVITY") Then
    Set ltable = O.Tables("ACTIVITY")
    If O.TableExists("GEN-INFO") Then
      nExits = O.Tables("GEN-INFO").Parms("NEXITS")
    Else
      nExits = 1
    End If
    
    'section hydr
    If ltable.Parms("HYDRFG") = 1 Then
      If O.TableExists("HYDR-PARM1") Then
        AUX2FG = O.Tables("HYDR-PARM1").Parms("AUX2FG")
        AUX3FG = O.Tables("HYDR-PARM1").Parms("AUX3FG")
      Else
        AUX2FG = 0
        AUX2FG = 0
      End If
      TimserStatus.Change "HYDR:VOL", 1, HspfStatusOptional
      If Not O.Uci.CategoryBlock Is Nothing Then
        'have category block
        For i = 1 To O.Uci.CategoryBlock.Count
          TimserStatus.Change "HYDR:CVOL", i, HspfStatusOptional
        Next i
      End If
      
      TimserStatus.Change "HYDR:DEP", 1, HspfStatusOptional
      TimserStatus.Change "HYDR:STAGE", 1, HspfStatusOptional
      TimserStatus.Change "HYDR:AVDEP", 1, HspfStatusOptional
      TimserStatus.Change "HYDR:TWID", 1, HspfStatusOptional
      TimserStatus.Change "HYDR:HRAD", 1, HspfStatusOptional
      TimserStatus.Change "HYDR:SAREA", 1, HspfStatusOptional
      'auxflgs
      If AUX2FG = 1 Then
        TimserStatus.Change "HYDR:AVVEL", 1, HspfStatusOptional
        TimserStatus.Change "HYDR:AVSECT", 1, HspfStatusOptional
      End If
      If AUX3FG = 1 Then
        TimserStatus.Change "HYDR:USTAR", 1, HspfStatusOptional
        TimserStatus.Change "HYDR:TAU", 1, HspfStatusOptional
      End If
      TimserStatus.Change "HYDR:RO", 1, HspfStatusOptional
      If Not O.Uci.CategoryBlock Is Nothing Then
        'have category block
        For i = 1 To O.Uci.CategoryBlock.Count
          TimserStatus.Change "HYDR:CRO", i, HspfStatusOptional
        Next i
      End If
      
      TimserStatus.Change "ROFLOW:ROVOL", 1, HspfStatusOptional
      If Not O.Uci.CategoryBlock Is Nothing Then
        'have category block
        For i = 1 To O.Uci.CategoryBlock.Count
          TimserStatus.Change "ROFLOW:CROVOL", i, HspfStatusOptional
        Next i
      End If
      
      If nExits > 1 Then
        For i = 1 To nExits
          TimserStatus.Change "HYDR:O", i, HspfStatusOptional
          If Not O.Uci.CategoryBlock Is Nothing Then
            'have category block
            For j = 1 To O.Uci.CategoryBlock.Count
              TimserStatus.Change2 "HYDR:CO", i, j, HspfStatusOptional
              TimserStatus.Change2 "HYDR:CDFVOL", i, j, HspfStatusOptional
              TimserStatus.Change2 "HYDR:COVOL", i, j, HspfStatusOptional
              TimserStatus.Change2 "OFLOW:COVOL", i, j, HspfStatusOptional
            Next j
          End If
          TimserStatus.Change "OFLOW:OVOL", i, HspfStatusOptional
          TimserStatus.Change "HYDR:OVOL", i, HspfStatusOptional
        Next i
      End If
      TimserStatus.Change "HYDR:IVOL", 1, HspfStatusOptional
      If Not O.Uci.CategoryBlock Is Nothing Then
        'have category block
        For i = 1 To O.Uci.CategoryBlock.Count
          TimserStatus.Change "HYDR:CIVOL", i, HspfStatusOptional
        Next i
      End If
      
      TimserStatus.Change "HYDR:PRSUPY", 1, HspfStatusOptional
      TimserStatus.Change "HYDR:VOLEV", 1, HspfStatusOptional
      TimserStatus.Change "HYDR:ROVOL", 1, HspfStatusOptional
      If Not O.Uci.CategoryBlock Is Nothing Then
        'have category block
        For i = 1 To O.Uci.CategoryBlock.Count
          TimserStatus.Change "HYDR:CROVOL", i, HspfStatusOptional
        Next i
      End If
      
      TimserStatus.Change "HYDR:RIRDEM", 1, HspfStatusOptional
      TimserStatus.Change "HYDR:RIRSHT", 1, HspfStatusOptional
    End If
    
    'section cons
    If ltable.Parms("CONSFG") = 1 Then
      If O.TableExists("NCONS") Then
        nCons = O.Tables("NCONS").Parms("NCONS")
      Else
        nCons = 0
      End If
      For i = 1 To nCons
        TimserStatus.Change "CONS:CON", i, HspfStatusOptional
        TimserStatus.Change "CONS:ICON", i, HspfStatusOptional
        TimserStatus.Change "CONS:COADDR", i, HspfStatusOptional
        TimserStatus.Change "CONS:COADWT", i, HspfStatusOptional
        TimserStatus.Change "CONS:COADEP", i, HspfStatusOptional
        TimserStatus.Change "CONS:ROCON", i, HspfStatusOptional
        TimserStatus.Change "ROFLOW:ROCON", i, HspfStatusOptional
        If nExits > 1 Then
          For j = 1 To nExits
            TimserStatus.Change2 "CONS:OCON", j, i, HspfStatusOptional
            TimserStatus.Change2 "OFLOW:OCON", j, i, HspfStatusOptional
          Next j
        End If
      Next i
    End If
    
    'section htrch
    If ltable.Parms("HTFG") = 1 Then
      TimserStatus.Change "HTRCH:TW", 1, HspfStatusOptional
      TimserStatus.Change "HTRCH:AIRTMP", 1, HspfStatusOptional
      TimserStatus.Change "HTRCH:IHEAT", 1, HspfStatusOptional
      TimserStatus.Change "HTRCH:HTEXCH", 1, HspfStatusOptional
      TimserStatus.Change "HTRCH:ROHEAT", 1, HspfStatusOptional
      TimserStatus.Change "HTRCH:SHDFAC", 1, HspfStatusOptional
      TimserStatus.Change "ROFLOW:ROHEAT", 1, HspfStatusOptional
      If nExits > 1 Then
        For i = 1 To nExits
          TimserStatus.Change "HTRCH:OHEAT", i, HspfStatusOptional
          TimserStatus.Change "OFLOW:OHEAT", i, HspfStatusOptional
        Next i
      End If
      For i = 1 To 7
        TimserStatus.Change "HTRCH:HTCF4", i, HspfStatusOptional
      Next i
    End If

    'section sedtran
    If ltable.Parms("SEDFG") = 1 Then
      For i = 1 To 4
        TimserStatus.Change "SEDTRN:SSED", i, HspfStatusOptional
        TimserStatus.Change "SEDTRN:ISED", i, HspfStatusOptional
        TimserStatus.Change "SEDTRN:DEPSCR", i, HspfStatusOptional
        TimserStatus.Change "SEDTRN:ROSED", i, HspfStatusOptional
      Next i
      For i = 1 To 3
        TimserStatus.Change "ROFLOW:ROSED", i, HspfStatusOptional
        TimserStatus.Change "SEDTRN:TSED", i, HspfStatusOptional
      Next i
      For i = 1 To 10
        TimserStatus.Change "SEDTRN:RSED", i, HspfStatusOptional
      Next i
      TimserStatus.Change "SEDTRN:BEDDEP", 1, HspfStatusOptional
      If nExits > 1 Then
        For j = 1 To 4
          For i = 1 To nExits
            TimserStatus.Change2 "SEDTRN:OSED", i, j, HspfStatusOptional
          Next i
        Next j
        For j = 1 To 3
          For i = 1 To nExits
            TimserStatus.Change2 "OFLOW:OSED", i, j, HspfStatusOptional
          Next i
        Next j
      End If
    End If
    
    'section gqual
    If ltable.Parms("GQALFG") = 1 Then
      If O.TableExists("GQ-GENDATA") Then
        nGqual = O.Tables("GQ-GENDATA").Parms("NGQUAL")
      Else
        nGqual = 1
      End If
      For i = 1 To nGqual
        TimserStatus.Change "GQUAL:DQAL", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:RDQAL", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:RRQAL", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:IDQAL", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:TIQAL", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:PDQAL", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:GQADDR", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:GQADWT", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:GQADEP", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:RODQAL", i, HspfStatusOptional
        TimserStatus.Change "GQUAL:TROQAL", i, HspfStatusOptional
        TimserStatus.Change "ROFLOW:RODQAL", i, HspfStatusOptional
        For j = 1 To 7
          TimserStatus.Change2 "GQUAL:DDQAL", j, i, HspfStatusOptional
          TimserStatus.Change2 "GQUAL:SQDEC", j, i, HspfStatusOptional
          TimserStatus.Change2 "GQUAL:ADQAL", j, i, HspfStatusOptional
        Next j
        For j = 1 To 12
          TimserStatus.Change2 "GQUAL:RSQAL", j, i, HspfStatusOptional
        Next j
        For j = 1 To 6
          TimserStatus.Change2 "GQUAL:SQAL", j, i, HspfStatusOptional
        Next j
        For j = 1 To 4
          TimserStatus.Change2 "GQUAL:DSQAL", j, i, HspfStatusOptional
          TimserStatus.Change2 "GQUAL:ISQAL", j, i, HspfStatusOptional
          TimserStatus.Change2 "GQUAL:ROSQAL", j, i, HspfStatusOptional
        Next j
        For j = 1 To 3
          TimserStatus.Change2 "ROFLOW:ROSQAL", j, i, HspfStatusOptional
        Next j
        If nExits > 1 Then
          For j = 1 To nExits
            TimserStatus.Change2 "GQUAL:ODQAL", j, i, HspfStatusOptional
            TimserStatus.Change2 "GQUAL:TOSQAL", j, i, HspfStatusOptional
            TimserStatus.Change2 "OFLOW:ODQAL", j, i, HspfStatusOptional
            TimserStatus.Change2 "GQUAL:OSQAL", j, i, HspfStatusOptional
            TimserStatus.Change2 "OFLOW:OSQAL", j, i, HspfStatusOptional
            TimserStatus.Change2 "GQUAL:OSQAL", j, i + 1, HspfStatusOptional
            TimserStatus.Change2 "OFLOW:OSQAL", j, i + 1, HspfStatusOptional
            TimserStatus.Change2 "GQUAL:OSQAL", j, i + 2, HspfStatusOptional
            TimserStatus.Change2 "OFLOW:OSQAL", j, i + 2, HspfStatusOptional
          Next j
        End If
      Next i
    End If
    
    'section oxrx
    If ltable.Parms("OXFG") = 1 Then
      TimserStatus.Change "OXRX:DOX", 1, HspfStatusOptional
      TimserStatus.Change "OXRX:BOD", 1, HspfStatusOptional
      TimserStatus.Change "OXRX:SATDO", 1, HspfStatusOptional
      TimserStatus.Change "OXRX:OXIF", 1, HspfStatusOptional
      TimserStatus.Change "OXRX:OXIF", 2, HspfStatusOptional
      TimserStatus.Change "OXRX:OXCF1", 1, HspfStatusOptional
      TimserStatus.Change "OXRX:OXCF1", 2, HspfStatusOptional
      TimserStatus.Change "ROFLOW:OXCF1", 1, HspfStatusOptional
      TimserStatus.Change "ROFLOW:OXCF1", 2, HspfStatusOptional
      If nExits > 1 Then
        For j = 1 To nExits
          TimserStatus.Change2 "OXRX:OXCF2", j, 1, HspfStatusOptional
          TimserStatus.Change2 "OXRX:OXCF2", j, 2, HspfStatusOptional
          TimserStatus.Change2 "OFLOW:OXCF2", j, 1, HspfStatusOptional
          TimserStatus.Change2 "OFLOW:OXCF2", j, 2, HspfStatusOptional
        Next j
      End If
      For j = 1 To 8
        TimserStatus.Change "OXRX:OXCF3", j, HspfStatusOptional
        TimserStatus.Change "OXRX:OXCF4", j, HspfStatusOptional
      Next j
    End If
    
    'section nutrx
    If ltable.Parms("NUTFG") = 1 Then
      TimserStatus.Change "NUTRX:NUCF6", 1, HspfStatusOptional
      For i = 1 To 3
        TimserStatus.Change "NUTRX:SNH4", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:SPO4", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:NUADDR", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:NUADWT", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:NUADEP", i, HspfStatusOptional
      Next i
      For i = 1 To 12
        TimserStatus.Change "NUTRX:RSNH4", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:RSPO4", i, HspfStatusOptional
      Next i
      For i = 1 To 4
        TimserStatus.Change "NUTRX:NUST", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:NUCF1", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:NUIF1", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:TNUIF", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:TNUCF1", i, HspfStatusOptional
        TimserStatus.Change "ROFLOW:NUCF1", i, HspfStatusOptional
      Next i
      For i = 1 To 6
        TimserStatus.Change "NUTRX:DNUST", i, HspfStatusOptional
        TimserStatus.Change "NUTRX:DNUST2", i, HspfStatusOptional
      Next i
      For i = 1 To 7
        TimserStatus.Change "NUTRX:NUCF4", i, HspfStatusOptional
      Next i
      For i = 1 To 8
        TimserStatus.Change "NUTRX:NUCF5", i, HspfStatusOptional
      Next i
      For i = 1 To 6
        TimserStatus.Change "NUTRX:NUCF7", i, HspfStatusOptional
      Next i
      For i = 1 To 3
        For j = 1 To 2
          TimserStatus.Change2 "ROFLOW:NUCF2", i, j, HspfStatusOptional
        Next j
      Next i
      For i = 1 To 4
        For j = 1 To 2
          TimserStatus.Change2 "NUTRX:NUIF2", i, j, HspfStatusOptional
          TimserStatus.Change2 "NUTRX:NUCF2", i, j, HspfStatusOptional
          TimserStatus.Change2 "NUTRX:NUCF3", i, j, HspfStatusOptional
          TimserStatus.Change2 "NUTRX:NUCF8", i, j, HspfStatusOptional
        Next j
      Next i
      If nExits > 1 Then
        For i = 1 To nExits
          For j = 1 To 4
            TimserStatus.Change2 "NUTRX:NUCF9", i, j, HspfStatusOptional
            TimserStatus.Change2 "OFLOW:NUCF9", i, j, HspfStatusOptional
            TimserStatus.Change2 "NUTRX:OSNH4", i, j, HspfStatusOptional
            TimserStatus.Change2 "NUTRX:OSPO4", i, j, HspfStatusOptional
            TimserStatus.Change2 "NUTRX:TNUCF2", i, j, HspfStatusOptional
          Next j
          For j = 1 To 3
            TimserStatus.Change2 "OFLOW:OSNH4", i, j, HspfStatusOptional
            TimserStatus.Change2 "OFLOW:OSPO4", i, j, HspfStatusOptional
          Next j
        Next i
      End If
    End If
    
    'section plank
    If ltable.Parms("PLKFG") = 1 Then
      TimserStatus.Change "PLANK:PHYTO", 1, HspfStatusOptional
      TimserStatus.Change "PLANK:ZOO", 1, HspfStatusOptional
      For i = 1 To 4
        TimserStatus.Change "PLANK:BENAL", i, HspfStatusOptional
      Next i
      TimserStatus.Change "PLANK:TBENAL", 1, HspfStatusOptional
      TimserStatus.Change "PLANK:TBENAL", 2, HspfStatusOptional
      TimserStatus.Change "PLANK:PHYCLA", 1, HspfStatusOptional
      For i = 1 To 4
        TimserStatus.Change "PLANK:BALCLA", i, HspfStatusOptional
      Next i
      For i = 1 To 7
        TimserStatus.Change "PLANK:PKST3", i, HspfStatusOptional
      Next i
      TimserStatus.Change "PLANK:PKST4", 1, HspfStatusOptional
      TimserStatus.Change "PLANK:PKST4", 2, HspfStatusOptional
      For i = 1 To 5
        TimserStatus.Change "PLANK:PKIF", i, HspfStatusOptional
        TimserStatus.Change "PLANK:TPKIF", i, HspfStatusOptional
        TimserStatus.Change "PLANK:PKCF1", i, HspfStatusOptional
        TimserStatus.Change "ROFLOW:PKCF1", i, HspfStatusOptional
        TimserStatus.Change "PLANK:TPKCF1", i, HspfStatusOptional
        TimserStatus.Change "PLANK:PKCF5", i, HspfStatusOptional
        TimserStatus.Change "PLANK:PKCF8", i, HspfStatusOptional
        TimserStatus.Change "PLANK:PKCF9", i, HspfStatusOptional
        TimserStatus.Change "PLANK:PKCF10", i, HspfStatusOptional
        If nExits > 1 Then
          For j = 1 To nExits
            TimserStatus.Change2 "PLANK:PKCF2", j, i, HspfStatusOptional
            TimserStatus.Change2 "OFLOW:PKCF2", j, i, HspfStatusOptional
            TimserStatus.Change2 "PLANK:TPKCF2", j, i, HspfStatusOptional
          Next j
        End If
      Next i
      For i = 1 To 3
        TimserStatus.Change "PLANK:PLADDR", i, HspfStatusOptional
        TimserStatus.Change "PLANK:PLADWT", i, HspfStatusOptional
        TimserStatus.Change "PLANK:PLADEP", i, HspfStatusOptional
        TimserStatus.Change "PLANK:PKCF6", i, HspfStatusOptional
        TimserStatus.Change "PLANK:TPKCF7", i, HspfStatusOptional
      Next i
      For i = 1 To 4
        For j = 1 To 3
          TimserStatus.Change2 "PLANK:PKCF7", j, i, HspfStatusOptional
        Next j
      Next i
    End If
      
    'section phcarb
    If ltable.Parms("PHFG") = 1 Or ltable.Parms("PHFG") = 3 Then
      TimserStatus.Change "PHCARB:SATCO2", 1, HspfStatusOptional
      For i = 1 To 3
        TimserStatus.Change "PHCARB:PHST", i, HspfStatusOptional
      Next i
      For i = 1 To 2
        TimserStatus.Change "PHCARB:PHIF", i, HspfStatusOptional
        TimserStatus.Change "PHCARB:PHCF1", i, HspfStatusOptional
        TimserStatus.Change "ROFLOW:PHCF1", i, HspfStatusOptional
        If nExits > 1 Then
          For j = 1 To nExits
            TimserStatus.Change2 "PHCARB:PHCF2", j, i, HspfStatusOptional
            TimserStatus.Change2 "OFLOW:PHCF2", j, i, HspfStatusOptional
          Next j
        End If
      Next i
      For i = 1 To 7
        TimserStatus.Change "PHCARB:PHCF3", i, HspfStatusOptional
      Next i
    End If
    
    Dim lAcidph As Boolean
    lAcidph = False
    'check to see if acidph is available
    For i = 1 To O.Uci.Msg.BlockDefs("RCHRES").SectionDefs.Count
      If O.Uci.Msg.BlockDefs("RCHRES").SectionDefs(i).Name = "ACIDPH" Then
        lAcidph = True
      End If
    Next i
    If lAcidph Then
      'section acidph
      If ltable.Parms("PHFG") = 2 Or ltable.Parms("PHFG") = 3 Then
        TimserStatus.Change "ACIDPH:ACPH", 1, HspfStatusOptional
        For i = 1 To 7
          TimserStatus.Change "ACIDPH:ACCONC", i, HspfStatusOptional
          TimserStatus.Change "ACIDPH:ACSTOR", i, HspfStatusOptional
          TimserStatus.Change "ACIDPH:ACFLX1", i, HspfStatusOptional
          TimserStatus.Change "ROFLOW:ACFLX1", i, HspfStatusOptional
          If nExits > 1 Then
            For j = 1 To nExits
              TimserStatus.Change2 "ACIDPH:ACFLX2", j, i, HspfStatusOptional
              TimserStatus.Change2 "OFLOW:ACFLX2", j, i, HspfStatusOptional
            Next j
          End If
        Next i
      End If
    End If
      
  End If
End Sub

