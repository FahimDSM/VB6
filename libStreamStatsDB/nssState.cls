VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "nssState"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'Copyright 2001 by AQUA TERRA Consultants

Private pName As String
Private pCode As String
Private pDB As nssDatabase
Private pAbbrev As String
Private pMetric As Boolean
Private pStatebasin As ssStateBasin
Private pStateBasins As FastCollection   'of ssBasin
Private pCounty As ssCounty
Private pCounties As FastCollection      'of ssCounty
Private pMCD As ssMCD
Private pMCDs As FastCollection          'of ssMCD
Private pHUC As ssHUC
Private pHUCs As FastCollection          'of ssHUCS
Private pStations As FastCollection      'of ssStation
Private pSelStation As ssStation
Private pSelStations As FastCollection   'of selected ssStation
Private pRegions As FastCollection       'of nssRegion
Private pStatsOnFile As FastCollection   'of nssParameter
Private pROIPeakData As nssROI
Private pROILowData As nssROI

'Private pROIClimateFactor As Boolean
'Private pROIDistance As Boolean
'Private pROIRegress As Boolean
'Private pROIUseRegions As Boolean
'Private pROISimStations As Integer       'number of similar stations to use
'Private pROIParms As FastCollection      'of nssparameter
'Private pROIStations As FastCollection   'of ssStation
'Private pROIPeakFlows As FastCollection  'of ssStatistic

Public Property Get Name() As String
  Name = pName
End Property
Public Property Let Name(ByVal newValue As String)
  pName = newValue
End Property

Public Property Get code() As String
  code = pCode
End Property
Public Property Let code(ByVal newValue As String)
  pCode = newValue
End Property

Public Property Get DB() As nssDatabase
  Set DB = pDB
End Property
Public Property Set DB(newValue As nssDatabase)
  Set pDB = newValue
End Property

'2-letter abbreviation
Public Property Get Abbrev() As String
  Abbrev = pAbbrev
End Property
Public Property Let Abbrev(ByVal newValue As String)
  pAbbrev = newValue
End Property

Public Property Get Metric() As Boolean
  Metric = pMetric
End Property
Public Property Let Metric(ByVal newValue As Boolean)
  pMetric = newValue
End Property

Public Property Get ROIPeakData() As nssROI
  Set ROIPeakData = pROIPeakData
End Property
Public Property Set ROIPeakData(newValue As nssROI)
  Set pROIPeakData = newValue
End Property

Public Property Get ROILowData() As nssROI
  Set ROILowData = pROILowData
End Property
Public Property Set ROILowData(newValue As nssROI)
  Set pROILowData = newValue
End Property

'Public Property Get ROIClimateFactor() As Boolean
'  ROIClimateFactor = pROIClimateFactor
'End Property
'Public Property Let ROIClimateFactor(ByVal newValue As Boolean)
'  pROIClimateFactor = newValue
'End Property
'
'Public Property Get ROIDistance() As Boolean
'  ROIDistance = pROIDistance
'End Property
'Public Property Let ROIDistance(ByVal newValue As Boolean)
'  pROIDistance = newValue
'End Property
'
'Public Property Get ROIRegress() As Boolean
'  ROIRegress = pROIRegress
'End Property
'Public Property Let ROIRegress(ByVal newValue As Boolean)
'  pROIRegress = newValue
'End Property
'
'Public Property Get ROIUseRegions() As Boolean
'  ROIUseRegions = pROIUseRegions
'End Property
'Public Property Let ROIUseRegions(ByVal newValue As Boolean)
'  pROIUseRegions = newValue
'End Property
'
'Public Property Get ROISimStations() As Integer
'  ROISimStations = pROISimStations
'End Property
'Public Property Let ROISimStations(ByVal newValue As Integer)
'  pROISimStations = newValue
'End Property

Public Property Get Statebasin() As ssStateBasin
  Set Statebasin = pStatebasin
End Property
Public Property Set Statebasin(ByVal newValue As ssStateBasin)
  Set pStatebasin = newValue
End Property

Public Property Get HUC() As ssHUC
  Set HUC = pHUC
End Property
Public Property Set HUC(ByVal newValue As ssHUC)
  Set pHUC = newValue
End Property

Public Property Set HUCs(ByRef newValue As FastCollection)
  Set pHUCs = newValue
End Property
Public Property Get HUCs() As FastCollection
  If pHUCs Is Nothing Then PopulateHUCs
  Set HUCs = pHUCs
End Property

Private Sub PopulateHUCs()
  Dim hucRec As Recordset
  Dim newHUC As ssHUC
  Dim sql$
  
  Set pHUCs = New FastCollection
  If pDB Is Nothing Then
    ssMessageBox "Cannot read HUCs" & vbCr & "DB not set."
  Else
    'builds collection of HUCs
    sql = "SELECT * FROM [HUC] WHERE StateCode='" & pCode & _
          "' ORDER BY HUC;"
    Set hucRec = pDB.DB.OpenRecordset(sql, dbOpenForwardOnly)
    While Not hucRec.EOF
      Set newHUC = New ssHUC
      With newHUC
        Set .DB = pDB
        Set .State = Me
        .Name = Trim(hucRec.Fields("HUCName"))
        .code = Trim(hucRec.Fields("HUC"))
      End With
      pHUCs.Add newHUC, newHUC.code
      Set newHUC = Nothing
      hucRec.MoveNext
    Wend
    hucRec.Close
  End If
End Sub

Public Property Set StateBasins(ByRef newValue As FastCollection)
  Set pStateBasins = newValue
End Property
Public Property Get StateBasins() As FastCollection
  ' Code must be set for this state before this will work
  If pStateBasins Is Nothing Then PopulateStateBasins
  Set StateBasins = pStateBasins
End Property
Public Sub PopulateStateBasins()
  Dim newStateBasin As ssStateBasin
  Dim basinRec As Recordset
  Dim sql$

  Set pStateBasins = New FastCollection
  If pDB Is Nothing Then
    ssMessageBox "Cannot read State Basins" & vbCr & "DB not set."
  Else
    sql = "SELECT * From STATEBASIN " & _
        "WHERE STATEBASIN.StateCode='" & pCode & _
        "' ORDER BY StateBasinCode;"
    Set basinRec = pDB.DB.OpenRecordset(sql)
    While Not basinRec.EOF
      Set newStateBasin = New ssStateBasin
      With newStateBasin
        Set .DB = pDB
        Set .State = Me
        .Name = basinRec.Fields("StateBasin")
        .code = basinRec.Fields("StateBasinCode")
      End With
      pStateBasins.Add newStateBasin, newStateBasin.code
      Set newStateBasin = Nothing
      basinRec.MoveNext
    Wend
    basinRec.Close
  End If
End Sub

Public Property Get County() As ssCounty
  Set County = pCounty
End Property
Public Property Set County(ByVal newValue As ssCounty)
  Set pCounty = newValue
End Property

Public Property Set Counties(ByRef newValue As FastCollection)
  Set pCounties = newValue
End Property
Public Property Get Counties() As FastCollection
  ' Code must be set for this state before this will work
  If pCounties Is Nothing Then PopulateCounties
  Set Counties = pCounties
End Property

Public Sub PopulateCounties()
  Dim newCounty As ssCounty
  Dim countyRec As Recordset
  Dim sql$
  
  Set pCounties = New FastCollection
  If pDB Is Nothing Then
    ssMessageBox "Cannot read Counties" & vbCr & "DB not set."
  Else
    sql = "SELECT COUNTY.* FROM [COUNTY] WHERE " & _
          "COUNTY.StateCode='" & pCode & "';"
    Set countyRec = pDB.DB.OpenRecordset(sql)
    While Not countyRec.EOF
      Set newCounty = New ssCounty
      With newCounty
        Set .DB = pDB
        Set .State = Me
        .code = countyRec.Fields("CountyCode")
        .Name = countyRec.Fields("County")
      End With
      pCounties.Add newCounty, newCounty.code
      Set newCounty = Nothing
      countyRec.MoveNext
    Wend
    countyRec.Close
  End If
End Sub

Public Property Get MCD() As ssMCD
  Set MCD = pMCD
End Property
Public Property Set MCD(ByVal newValue As ssMCD)
  Set pMCD = newValue
End Property

Public Property Set MCDs(ByRef newValue As FastCollection)
  Set pMCDs = newValue
End Property
Public Property Get MCDs() As FastCollection
  ' Code must be set for this state before this will work
  If pMCDs Is Nothing Then PopulateMCDs
  Set MCDs = pMCDs
End Property

Public Sub PopulateMCDs()
  Dim newMCD As ssMCD
  Dim MCDRec As Recordset
  Dim sql$

  Set pMCDs = Nothing
  Set pMCDs = New FastCollection
  If pDB Is Nothing Then
    ssMessageBox "Cannot read MCDs" & vbCr & "DB not set."
  Else
    sql = "SELECT MCD.* FROM [MCD] " & _
          "WHERE MCD.StateCode='" & pCode & "';"
    Set MCDRec = pDB.DB.OpenRecordset(sql, dbOpenDynaset)
    While Not MCDRec.EOF
      Set newMCD = New ssMCD
      With newMCD
        Set .DB = pDB
        Set .State = Me
        .code = MCDRec.Fields("MCDCode")
        .Name = MCDRec.Fields("MCDName")
      End With
      pMCDs.Add newMCD, newMCD.code
      Set newMCD = Nothing
      MCDRec.MoveNext
    Wend
    MCDRec.Close
  End If
End Sub

Public Property Set Stations(ByRef newValue As FastCollection)
  Set pStations = newValue
End Property
Public Property Get Stations() As FastCollection
  ' Code must be set for this state before this will work
  If pStations Is Nothing Then PopulateStations
  Set Stations = pStations
End Property
Private Sub PopulateStations()
  Dim newStation As ssStation
  Dim stationRec As Recordset
  Dim sql$
  
  Set pStations = New FastCollection
  If pDB Is Nothing Then
    ssMessageBox "Cannot read Stations" & vbCr & "DB not set."
  Else
'    sql = "SELECT Station.* FROM [Station] WHERE " & _
'          "Station.StateCode='" & pCode & _
'          "' ORDER BY StaID;"
    
    sql = "SELECT STATION.*, [StationState].[ROI] " & _
          "FROM [StationState] INNER JOIN STATION ON [StationState].[StaID]=[STATION].[StaID] " & _
          "WHERE [StationState].[StateCode]='" & pCode & "' ORDER BY STATION.StaID;"
    Set stationRec = pDB.DB.OpenRecordset(sql, dbOpenForwardOnly)
    While Not stationRec.EOF
      Set newStation = New ssStation
      With newStation
        Set .DB = pDB
        Set .State = Me
        .Id = stationRec("StaID")
        If Not IsNull(stationRec("StationName")) Then .Name = stationRec("StationName")
        If Not IsNull(stationRec("StationName")) Then
          .Label = stationRec("StationName")
        ElseIf Not IsNull(stationRec("StaID")) Then
          .Label = stationRec("StaID")
        End If
        If Not IsNull(stationRec("Agency_cd")) Then .AgencyCode = stationRec("Agency_cd")
        If Not IsNull(stationRec("StationTypeCode")) Then Set .StationType = GetStationType(stationRec("StationTypeCode"))
        If Not IsNull(stationRec("IsRegulated")) Then .IsRegulated = stationRec("IsRegulated")
        If Not IsNull(stationRec("PeriodOfRecord")) Then .Period = stationRec("PeriodOfRecord")
        If Not IsNull(stationRec("StationRemarks")) Then .Remarks = stationRec("StationRemarks")
        If Not IsNull(stationRec("Latitude")) Then .Latitude = stationRec("Latitude")
        If Not IsNull(stationRec("Longitude")) Then .Longitude = stationRec("Longitude")
        If Not IsNull(stationRec("HUC")) Then .HUCCode = stationRec("HUC")
        If Not IsNull(stationRec("Statebasin")) Then .StatebasinCode = stationRec("Statebasin")
        If Not IsNull(stationRec("CountyCode")) Then .CountyCode = stationRec("CountyCode")
        'If Not IsNull(stationRec("MCDCode")) Then .MCDCode = stationRec("MCDCode")
        If Not IsNull(stationRec("Directions")) Then .Directions = stationRec("Directions")
        'If Not IsNull(stationRec("HasData")) Then .HasData = stationRec("HasData")
        If Not IsNull(stationRec("StateCode")) Then .StateCode = stationRec("StateCode")
        If Not IsNull(stationRec("DistrictCode")) Then .DistrictCode = stationRec("DistrictCode")
        If Not IsNull(stationRec("HCDN")) Then .HCDN = stationRec("HCDN")
        If Not IsNull(stationRec("Station_md")) Then .StationMd = Split(stationRec("Station_md").Value)(0)
        
        If Not IsNull(stationRec("ROI")) Then
          .ROIIndex = stationRec("ROI")
          .IsROI = .ROIIndex
        End If
        .IsNew = False
      End With
      'NOTE: This conditional handles the issue of having the same station twice
      '      for a state that has both High and Low flow ROI apps; PRH, 7/2009
      If Not pStations.KeyExists(newStation.Id) Then pStations.Add newStation, newStation.Id
      Set newStation = Nothing
      stationRec.MoveNext
    Wend
    stationRec.Close
  End If
End Sub

Public Property Set StatsOnFile(ByRef newValue As FastCollection)
  Set pStatsOnFile = newValue
End Property
Public Property Get StatsOnFile() As FastCollection
  ' ID must be set for this region before this will work
  If pStatsOnFile Is Nothing Then PopulateStatsOnFile
  Set StatsOnFile = pStatsOnFile
End Property
Public Sub PopulateStatsOnFile()
  Dim newStat As ssStatistic
  Dim statRec As Recordset
  Dim sql$

  If Not pStatsOnFile Is Nothing Then
    pStatsOnFile.Clear
    Set pStatsOnFile = Nothing
  End If
  Set pStatsOnFile = New FastCollection

  If pDB Is Nothing Then
    ssMessageBox "Cannot read StatsOnFile" & vbCr & "DB not set."
  Else
'    sql = "SELECT DISTINCT STATLABEL.StatisticLabelCode, STATLABEL.StatLabel, STATLABEL.Units, " & _
'        "STATLABEL.StatisticLabel, STATTYPE.StatisticTypeCode, STATTYPE.StatisticType " & _
'        "FROM STATTYPE INNER JOIN (STATLABEL INNER JOIN " & _
'        "(STATION INNER JOIN STATISTIC ON STATION.StaID = STATISTIC.StaID) " & _
'        "ON STATLABEL.StatisticLabelCode = STATISTIC.StatisticLabelCode) " & _
'        "ON STATTYPE.StatisticTypeCode = STATLABEL.StatisticTypeCode " & _
'        "WHERE STATION.StateCode='" & Me.Code & "' AND STATION.ROI>0;"
    sql = "SELECT DISTINCT STATLABEL.StatisticLabelID, STATLABEL.StatLabel, STATLABEL.UnitID, " & _
        "STATLABEL.StatisticLabel, STATTYPE.StatisticTypeCode, STATTYPE.StatisticType " & _
        "FROM STATTYPE INNER JOIN (STATLABEL INNER JOIN " & _
        "(([StationState] INNER JOIN STATION ON [StationState].[StaID]=[STATION].[StaID]) " & _
        "INNER JOIN STATISTIC ON STATION.StaID = STATISTIC.StaID) " & _
        "ON STATLABEL.StatisticLabelID = STATISTIC.StatisticLabelID) " & _
        "ON STATTYPE.StatisticTypeCode = STATLABEL.StatisticTypeCode " & _
        "WHERE [StationState].[StateCode]='" & Me.code & "' AND [StationState].[ROI]>0;"
    Set statRec = pDB.DB.OpenRecordset(sql)
    While Not statRec.EOF
      Set newStat = New ssStatistic
      With newStat
        If Not IsNull(statRec("StatisticTypeCode")) Then .StatTypeCode = statRec("StatisticTypeCode")
        If Not IsNull(statRec("StatisticType")) Then .StatType = statRec("StatisticType")
        If Not IsNull(statRec("StatisticLabelID")) Then .code = statRec("StatisticLabelID")
        If Not IsNull(statRec("StatisticLabel")) Then .Name = statRec("StatisticLabel")
        If Not IsNull(statRec("StatLabel")) Then .Abbrev = statRec("StatLabel")
        If Not IsNull(statRec("UnitID")) Then Set .Units = pDB.Units(CStr(statRec("UnitID")))
      End With
      pStatsOnFile.Add newStat, CStr(newStat.Abbrev)
      Set newStat = Nothing
      statRec.MoveNext
    Wend
    statRec.Close
  End If
End Sub

'Public Property Set ROIParms(ByRef newValue As FastCollection)
'  Set pROIParms = newValue
'End Property
'Public Property Get ROIParms() As FastCollection
'  If pROIParms Is Nothing Then PopulateROIParms
'  Set ROIParms = pROIParms
'End Property
'Private Sub PopulateROIParms()
'  Dim newParm As nssParameter
'  Dim parmRec As Recordset
'  Dim sql$
'  Dim i&
'
'  Set pROIParms = New FastCollection
'  If pDB Is Nothing Then
'    ssMessageBox "Cannot read ROIParms" & vbCr & "DB not set."
'  Else
'    sql = "SELECT STATLABEL.StatisticLabelID, STATLABEL.StatLabel, " & _
'        "STATLABEL.StatisticLabel, STATTYPE.StatisticTypeCode, STATTYPE.StatisticType, " & _
'        "ROIUserParms.PosNegCorrelation, ROIUserParms.SimVar, ROIUserParms.RegVar " & _
'        "FROM ROIUserParms " & _
'        "INNER JOIN (STATTYPE INNER JOIN STATLABEL ON STATTYPE.StatisticTypeCode = STATLABEL.StatisticTypeCode) " & _
'        "ON ROIUserParms.ParmID = STATLABEL.StatisticLabelID " & _
'        "Where ROIUserParms.StateID='" & pCode & "' " & _
'        "ORDER BY STATLABEL.StatisticLabelID;"
'    Set parmRec = pDB.DB.OpenRecordset(sql)
'    While Not parmRec.EOF
'      Set newParm = New nssParameter
'      With newParm
'        If Not IsNull(parmRec("StatisticLabelID")) Then .LabelCode = parmRec("StatisticLabelID")
'        If Not IsNull(parmRec("StatLabel")) Then .Abbrev = parmRec("StatLabel")
'        If Not IsNull(parmRec("StatisticLabel")) Then .Name = parmRec("StatisticLabel")
'        If Not IsNull(parmRec("StatisticTypeCode")) Then .StatTypeCode = parmRec("StatisticTypeCode")
'        If Not IsNull(parmRec("StatisticType")) Then .StatType = parmRec("StatisticType")
'        If Not IsNull(parmRec("PosNegCorrelation")) Then .CorrelationType = CSng(parmRec("PosNegCorrelation"))
'        If Not IsNull(parmRec("SimVar")) Then .SimulationVar = parmRec("SimVar")
'        If Not IsNull(parmRec("RegVar")) Then .RegressionVar = parmRec("RegVar")
'      End With
'      pROIParms.Add newParm, CStr(newParm.LabelCode)
'      Set newParm = Nothing
'      parmRec.MoveNext
'    Wend
'    parmRec.Close
'  End If
'End Sub

Public Property Get SelStation() As ssStation
  Set SelStation = pSelStation
End Property
Public Property Set SelStation(ByVal newValue As ssStation)
  Set pSelStation = newValue
End Property

Public Property Set SelStations(ByRef newValue As FastCollection)
  Set pSelStations = newValue
End Property
Public Property Get SelStations() As FastCollection
  If pSelStations Is Nothing Then Set pSelStations = New FastCollection
  Set SelStations = pSelStations
End Property

Private Function GetStationType(TypeCode As String) As ssStationType
  Dim myRec As Recordset
  
  Set GetStationType = New ssStationType
  Set myRec = pDB.DB.OpenRecordset("STATIONTYPE", dbOpenSnapshot)
  With myRec
    .FindFirst "StationTypeCode='" & TypeCode & "'"
    If Not .NoMatch Then
      Set GetStationType.DB = pDB
      GetStationType.code = .Fields("StationTypeCode")
      GetStationType.Name = .Fields("StationType")
    End If
  End With
End Function

Public Property Set Regions(ByRef newValue As FastCollection)
  Set pRegions = newValue
End Property
Public Property Get Regions() As FastCollection
  ' ID must be set for this state before this will work
  If pRegions Is Nothing Then PopulateRegions
  Set Regions = pRegions
End Property
Public Sub PopulateRegions()
  Dim newRegion As nssRegion
  Dim rgnRec As Recordset
  Dim sql$
  Dim RegnID As Integer
  
  Set pRegions = New FastCollection
  If pDB Is Nothing Then
    ssMessageBox "Cannot read regions" & vbCr & "DB not set."
  Else
    sql = "SELECT * From Regions WHERE StateCode='" & pCode & _
          "' ORDER BY RegionName;"
    Set rgnRec = pDB.DB.OpenRecordset(sql)
    While Not rgnRec.EOF
      RegnID = rgnRec.Fields("RegionID")
      Set newRegion = New nssRegion
      With newRegion
        Set .DB = pDB
        Set .State = Me
        .Id = RegnID
        .Name = rgnRec.Fields("RegionName")
        .Urban = rgnRec.Fields("Urban")
        .UrbanNeedsRural = rgnRec.Fields("UrbanNeedsRural")
        .PredInt = rgnRec.Fields("PredInt")
        .ROIRegnID = rgnRec.Fields("ROIRegionID")
        .LowFlowRegnID = rgnRec.Fields("LowFlow")
      End With
      pRegions.Add newRegion, newRegion.Name
      Set newRegion = Nothing
      rgnRec.MoveNext
    Wend
    rgnRec.Close
  End If
End Sub
Public Sub Edit(ByVal PeakFlows As String, ByVal Cf As Boolean, ByVal Distance As Boolean, _
                ByVal Regress As Boolean, ByVal Regions As Boolean, ByVal SimStations As Integer)
  Dim myRec As Recordset
  Dim sql$
  
  sql = "SELECT * FROM STATES WHERE StateCode='" & Me.code & "'"
  Set myRec = DB.DB.OpenRecordset(sql, dbOpenDynaset)
  With myRec
    .Edit
    !ROIPeakFlows = PeakFlows
    !ROIClimateFactor = Cf
    !ROIDistance = Distance
    !ROIBackStepRegression = Regress
    !roiRegions = Regions
    If IsNumeric(SimStations) Then !ROISimStations = SimStations
    .Update
    .Close
  End With
End Sub

Public Sub ClearState(DVTable As String)
  Dim regRec As Recordset, parmRec As Recordset, dvRec As Recordset, _
      comprec As Recordset, matrixRec As Recordset
  Dim sql$
  Dim i&, j
  
  On Error GoTo 0 'resume next
  
  i = 0
  If DVTable = "ReturnPeriods" Then
    sql = "SELECT Regions.* From [Regions] " & _
          "WHERE StateCode='" & Me.code & "' And LowFlow=0 And ROIRegionID=0;"
  ElseIf DVTable = "Statistics" Then
    sql = "SELECT Regions.* From [Regions] " & _
          "WHERE StateCode='" & Me.code & "' And LowFlow>0 And ROIRegionID=0;"
  ElseIf DVTable = "Probability" Then
    sql = "SELECT Regions.* From [Regions] " & _
          "WHERE StateCode='" & Me.code & "' And LowFlow<0;"
  End If
  Set regRec = pDB.DB.OpenRecordset(sql, dbOpenDynaset)
  While regRec.RecordCount > 0
    i = i + 1
    regRec.MoveLast
    sql = "SELECT * From [DepVars] WHERE RegionID=" & regRec("RegionID")
    Set dvRec = pDB.DB.OpenRecordset(sql, dbOpenDynaset)
    If dvRec.RecordCount > 0 Then
      j = 0
      While dvRec.RecordCount > 0
        j = j + 1
        dvRec.MoveLast
        sql = "SELECT * From [Components] WHERE DepVarID=" & dvRec("DepVarID")
        Set comprec = pDB.DB.OpenRecordset(sql, dbOpenDynaset)
        If comprec.RecordCount > 0 Then
          While comprec.RecordCount > 0
            comprec.MoveLast
            comprec.Delete
          Wend
        End If
        comprec.Close
        sql = "SELECT * From [Covariance] WHERE DepVarID=" & dvRec("DepVarID")
        Set matrixRec = pDB.DB.OpenRecordset(sql, dbOpenDynaset)
        If matrixRec.RecordCount > 0 Then
          While matrixRec.RecordCount > 0
            matrixRec.MoveLast
            matrixRec.Delete
          Wend
        End If
        matrixRec.Close
        dvRec.Delete
      Wend
    End If
    dvRec.Close
    sql = "SELECT Parameters.* From [Parameters] WHERE RegionID=" & regRec("RegionID")
    Set parmRec = pDB.DB.OpenRecordset(sql, dbOpenDynaset)
    If parmRec.RecordCount > 0 Then
      While parmRec.RecordCount > 0
        parmRec.MoveLast
        parmRec.Delete
      Wend
      parmRec.Close
    End If
    regRec.Delete
  Wend
  Set Me.Regions = Nothing
End Sub

'Public Property Set ROIStations(ByRef newValue As FastCollection)
'  Set pROIStations = newValue
'End Property
'Public Property Get ROIStations() As FastCollection
'  If pROIStations Is Nothing Then PopulateROIStations
'  Set ROIStations = pROIStations
'End Property
'Public Sub PopulateROIStations()
'  Dim newStation As ssStation
'  Dim stationRec As Recordset
'  Dim sql$
'
'  Set pROIStations = New FastCollection
'  If pDB Is Nothing Then
'    ssMessageBox "Cannot read Stations" & vbCr & "DB not set."
'  Else
''    sql = "SELECT STATION.* FROM STATION " & _
''        "WHERE STATION.StateCode='" & Me.code & _
''        "' ORDER BY STATION.ROI;"
'
'    sql = "SELECT STATION.* " & _
'          "FROM [StationState] INNER JOIN STATION ON [StationState].[StaID]=[STATION].[StaID] " & _
'          "WHERE [StationState].[StateCode]='" & Me.Code & "' " & _
'          "AND [StationState].[ROI]>0 ORDER BY [StationState].[ROI];"
'    Set stationRec = pDB.DB.OpenRecordset(sql, dbOpenDynaset)
'    While Not stationRec.EOF
'      Set newStation = New ssStation
'      With newStation
'        Set .DB = pDB
'        Set .State = Me
'        .ID = stationRec("StaID")
'        If Not IsNull(stationRec("StationName")) Then .Name = stationRec("StationName")
'        If Not IsNull(stationRec("StationName")) Then .Label = stationRec("StationName")
'        If Not IsNull(stationRec("StationTypeCode")) Then Set .StationType = GetStationType(stationRec("StationTypeCode"))
'        If Not IsNull(stationRec("IsRegulated")) Then .IsRegulated = stationRec("IsRegulated")
'        If Not IsNull(stationRec("PeriodOfRecord")) Then .Period = stationRec("PeriodOfRecord")
'        If Not IsNull(stationRec("StationRemarks")) Then .Remarks = stationRec("StationRemarks")
'        If Not IsNull(stationRec("Latitude")) Then .Latitude = stationRec("Latitude")
'        If Not IsNull(stationRec("Longitude")) Then .Longitude = stationRec("Longitude")
'        If Not IsNull(stationRec("HUC")) Then .HUCCode = stationRec("HUC")
'        If Not IsNull(stationRec("StatebasinCode")) Then .StatebasinCode = (stationRec("StatebasinCode"))
'        If Not IsNull(stationRec("CountyCode")) Then .CountyCode = stationRec("CountyCode")
'        If Not IsNull(stationRec("MCDCode")) Then .MCDCode = stationRec("MCDCode")
'        If Not IsNull(stationRec("Directions")) Then .Directions = stationRec("Directions")
'        'If Not IsNull(stationRec("HasData")) Then .HasData = stationRec("HasData")
'        Set .State = Me
'        .IsNew = False
'      End With
'      pROIStations.Add newStation, newStation.ID
'      Set newStation = Nothing
'      stationRec.MoveNext
'    Wend
'    stationRec.Close
'  End If
'End Sub
'
'Public Property Set ROIPeakFlows(ByVal newValue As FastCollection)
'  Set pROIPeakFlows = newValue
'End Property
'Public Property Get ROIPeakFlows() As FastCollection
'  If pROIPeakFlows Is Nothing Then PopulateROIPeakFlows
'  Set ROIPeakFlows = pROIPeakFlows
'End Property
'Private Sub PopulateROIPeakFlows()
'  Dim newParm As ssStatLabel
'  Dim myRec As Recordset, statRec As Recordset
'  Dim sql$, str$, thisRetPd$
'
'  Set pROIPeakFlows = New FastCollection
'  If pDB Is Nothing Then
'    ssMessageBox "Cannot read ROIPeakFlows" & vbCr & "DB not set."
'  Else
'    'Read StatisticLabelCodes from STATES table
'    sql = "SELECT ROIPeakFlows FROM [STATES] " & _
'          "WHERE StateCode='" & Me.Code & "';"
'    Set myRec = pDB.DB.OpenRecordset(sql)
'    If Not IsNull(myRec.Fields("ROIPeakFlows")) Then _
'        str = myRec.Fields("ROIPeakFlows")
'    'Match StatisticLabelCodes with statistics
'    Set statRec = pDB.DB.OpenRecordset("STATLABEL")
'    Set Me.DB.StatType = Me.DB.StatisticTypes("PFS")
'    While Not Len(Trim(str)) = 0
'      thisRetPd = StrSplit(str, ",", "")
'      Set newParm = Me.DB.StatType.StatLabels(thisRetPd)
'      pROIPeakFlows.Add newParm, newParm.Code
'      Set newParm = Nothing
'      statRec.MoveNext
'    Wend
'    statRec.Close
'    myRec.Close
'  End If
'End Sub

Public Function GetCode(aStateAbbrev As String) As Integer
  aStateAbbrev = Mid(aStateAbbrev, 1, 2)
  Dim myRec As Recordset
  Dim lSQL As String
  
  lSQL = "SELECT StateCode FROM States WHERE ST='" & aStateAbbrev & "';"
  Set myRec = pDB.DB.OpenRecordset(lSQL, dbOpenDynaset)
  If Not myRec Is Nothing Then
    With myRec
      .MoveLast
      .MoveFirst
      If .RecordCount > 0 Then
        GetCode = .Fields("StateCode")
      Else
        GetCode = -99
      End If
      .Close
    End With 'myRec
  End If
End Function

Public Function GetAbbrev(aStateCode As Integer) As String
  Dim myRec As Recordset
  Dim lSQL As String
  
  lSQL = "SELECT ST FROM States WHERE StateCode=" & aStateCode & ";"
  Set myRec = pDB.DB.OpenRecordset(lSQL, dbOpenDynaset)
  If Not myRec Is Nothing Then
    With myRec
      .MoveLast
      .MoveFirst
      If .RecordCount > 0 Then
        GetAbbrev = .Fields("ST")
      Else
        GetAbbrev = ""
      End If
      .Close
    End With 'myRec
  End If
End Function

Private Sub Class_Initialize()
  pAbbrev = "XX"
  pName = "Not Assigned"
End Sub
