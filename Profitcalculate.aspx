<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Profitcalculate.aspx.cs" Inherits="Profitcalculate" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        .button {
    display: block;
    width: 115px;
    height: 25px;
    background: #4E9CAF;
    padding: 10px;
    text-align: center;
    border-radius: 5px;
    color: white;
    font-weight: bold;
}
    </style>
    <script type="text/javascript" src="/crystalreportviewers13/js/crviewer/crv.js">
      </script> 
    <script type="text/javascript">


                function Print() {
                      var dvReport = document.getElementById("dvReport");
                      var frame1 = dvReport.getElementsByTagName("iframe")[0];
                      if (navigator.appName.indexOf("Internet Explorer") != -1) {
                          frame1.name = frame1.id;
                          window.frames[frame1.id].focus();
                          window.frames[frame1.id].print();
                      }
                      else {
                          var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
                          frameDoc.print();
                      }
                  }
            </script>
</head>
<body>
    <form id="form1" runat="server">
        <% 
            int x = 0;
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["code"])))
            {
                x = int.Parse(Request.QueryString["code"].ToString());
            }

             %>
        <a  style="font-size:large;text-decoration:none;float:left" class="button" href="indexpage.aspx">Back to Home</a>

            
        <input type="button"  class="button" id="btnPrint" style="margin:30px;height:46px;font-size:large"  runat="server" value="Direct print" onclick="Print()"/>
       
        
    <div id="dvReport">
        
        <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" AutoDataBind="true" ToolPanelView="None" />
    
            </div>
    </form>
</body>
</html>
