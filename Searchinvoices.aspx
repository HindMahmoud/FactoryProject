<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="Searchinvoices.aspx.cs" Inherits="Searchinvoices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
    <div class="row">
        <div class="col-xs-12" style="overflow-x:auto;height:700px">
          <div class="box">
            <div class="box-header">
              <h3 class="box-title">فواتير الشراء</h3>
                
                
              <div class="row">
                  <br />
                <div class=" col-md-3" style="width: 150px;">
                    
                  <input type="text" name="table_search" id="search1" class="form-control pull-right"  onkeyup="myFunction1()" placeholder="الفاتوره..">
                </div>
                  <div class="  col-md-3" style="width: 150px;">
                    
                  <input type="text" name="table_search" id="search11" class="form-control pull-right"  onkeyup="myFunction11()" placeholder="المورد..">
                </div>
              </div>
            </div>
              <br />
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% 
                      FactoryDBEntities db = new FactoryDBEntities();
                      DateTime d = DateTime.Now.Date;
                      var x = (from ss in db.import where ss.id !=0&&ss.roleType==roleType select ss).OrderBy(a=>a.date).ToList();
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>الفاتوره#</th>
                    <th>التاريخ#</th>
                    <th>المورد</th>
                    <th>الاجمالي</th>
                    <th>نسبه الخصم %</th>
                    <th>الاجمالي بعد الخصم</th>
                    <th>سداد</th>
                </tr>
                  <% foreach (var item in x)
    {
                           DateTime dd = Convert.ToDateTime(item.date);
                          string ddd = dd.ToString("yyyy/MM/dd");
                           %> 
                      
                <tr>
                   <td class="text-bold  fa fa-share" style="font-size:large"> <a href="editImport.aspx?id=<%=item.id %>"><% Response.Write(item.id); %></a></td>

                 <td><% Response.Write(ddd); %></td>
                 <td><% Response.Write(item.importer_name); %></td>
                 <td><% Response.Write(item.total); %></td>
                 <td><% Response.Write(item.discount); %></td>
                 <td><% Response.Write(item.Net_total); %></td>
                    <td><% Response.Write(item.payedvalue); %></td>
                  <td><%--<a  href='Searchinvoices.aspx?impprint=<%=item.id %>'>  <i class="fa fa-print text-blue"></i></a></td>
<%--                  --%> 
                 <a  href='Searchinvoices.aspx?impid=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>
              </tr>
                    <%  }
    }%>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
        </div>
        <div class="col-xs-12" style="overflow-x:auto;height:700px">
          <div class="box">
            <div class="box-header">
              <h3 class="box-title">فواتير المبيعات</h3>
                
              <div class="row">
                <div class=" col-md-3" style="width: 150px;">
                    
                  <input type="text" name="table_search" id="search2" class="form-control pull-right"  onkeyup="myFunction2()" placeholder="الفاتوره..">
                </div>
                  <div class="  col-md-3" style="width: 150px;">
                    
                  <input type="text" name="table_search" id="search22" class="form-control pull-right"  onkeyup="myFunction22()" placeholder="العميل..">
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable2">
                  <% 
                     
                      var xx = (from ss in db.invoice where ss.id !=0&&ss.typeRole==roleType select ss).OrderBy(a=>a.date).ToList();
                      if (xx != null)
                      {
                       %>
                <tr>
                    <th>الفاتوره#</th>
                    <th>التاريخ#</th>
                    <th>العميل</th>
                    <th>الاجمالي</th>
                    <th>نسبه الخصم %</th>
                    <th>الاجمالي بعد الخصم</th>
                    <th>سداد</th>
                    <th>صوره</th>
                </tr>
                  <% foreach (var item in xx)
                      {   DateTime dd = Convert.ToDateTime(item.date);
                          string ddd = dd.ToString("yyyy/MM/dd");
                           %> 
                      
                <tr>
                 <td class="text-bold  fa fa-share" style="font-size:large"> <a href="editInvoice.aspx?id=<%=item.inv_id %>"><% Response.Write(item.inv_id); %></a></td>
                 <td><% Response.Write(ddd); %></td>
                 <td><% Response.Write(item.customer_name); %></td>
                 <td><% Response.Write(item.total); %></td>
                 <td><% Response.Write(item.discount); %></td>
                 <td><% Response.Write(item.Nettotal); %></td>
                    <td><% Response.Write(item.payed); %></td>
             <%if (item.img != null)
                     { %>
                    <td><a href='photos/<%=item.img %>' target="_blank"><i class="fa fa-file-image-o"></i></a></td>
                    <%}
    else {  %><td></td><%} %>
                   <td><%--<a  href='Searchinvoices.aspx?invprint=<%=item.id %>'>  <i class="fa fa-print text-blue"></i></a></td>
                  --%><%-- <td><a  href='Searchinvoices.aspx?invprint2=<%=item.id %>'>  <i class="fa fa-print text-orange"></i></a></td>--%>
                   <a  href='Searchinvoices.aspx?invid=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>
                </tr>
                    <%  }
    }%>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
        </div>
      </div>
    
   
     <script>

        function myFunction1() {
            var input, filter, table, tr, td, i;
            input = document.getElementById("search1");
            filter = input.value.toUpperCase();
            table = document.getElementById("mytable");
            tr = table.getElementsByTagName("tr");
            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[0];
                if (td) {
                    if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }

        function myFunction11() {
            var input, filter, table, tr, td, i;
            input = document.getElementById("search11");
            filter = input.value.toUpperCase();
            table = document.getElementById("mytable");
            tr = table.getElementsByTagName("tr");
            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[2];
                if (td) {
                    if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
    <script>

        function myFunction2() {
            var input, filter, table, tr, td, i;
            input = document.getElementById("search2");
            filter = input.value.toUpperCase();
            table = document.getElementById("mytable2");
            tr = table.getElementsByTagName("tr");
            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[0];
                if (td) {
                    if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
    <script>

        function myFunction22() {
            var input, filter, table, tr, td, i;
            input = document.getElementById("search22");
            filter = input.value.toUpperCase();
            table = document.getElementById("mytable2");
            tr = table.getElementsByTagName("tr");
            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[2];
                if (td) {
                    if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
 <% }
           else
           {
               %><div   style="font-weight:bold"  class="text-center text-danger">ليس لديك صلاحيه لدخول الصفحه</div><%
           }
       }

       else
       {
           Response.Redirect("login.aspx");
       }%>
</asp:Content>

