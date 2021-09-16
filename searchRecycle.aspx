<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="searchRecycle.aspx.cs" Inherits="searchRecycle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {%>
    <div class="row">
        <div class="col-xs-12" style="overflow-x:auto;height:700px">
          <div class="box">
            <div class="box-header">
              <h3 class="box-title">فواتير اعادة التصنيع</h3>
                
                
              <div class="row">
                  <br />
                <div class=" col-md-3" style="width: 150px;">
                    
                  <input type="text" name="table_search" id="search1" class="form-control pull-right"  onkeyup="myFunction1()" placeholder="الفاتوره..">
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
                      var x = (from ss in db.destroy_invoices where ss.roletype==roleType select ss).OrderBy(a=>a.date_destroy_inv).ToList();
                      if (!string.IsNullOrEmpty(Request.QueryString["date1"]) && !string.IsNullOrEmpty(Request.QueryString["date2"]))
                      {
                          DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"].ToString());
                          DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"].ToString());
                          x =(from ss in db.destroy_invoices where ss.roletype==roleType&&ss.date_destroy_inv>=d1&&ss.date_destroy_inv<d2 select ss).OrderBy(a=>a.date_destroy_inv).ToList();

                      }
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>الفاتوره#</th>
                    <th>التاريخ#</th>
                    <th>الاجمالي</th>
                    <th> سعر التشغيل </th>
                    <th>اسم الصنف </th>
                    <th>الكمية</th>
                    <th>اسم المستخدم</th>
                </tr>
                  <% foreach (var item in x)
                     { DateTime dd = Convert.ToDateTime(item.date_destroy_inv);
                          string ddd = dd.ToString("yyyy/MM/dd");
                           %> 
                      
                <tr>
                   <td class="text-bold  fa fa-share" style="font-size:large"> <a href="editRcycle.aspx?edit=<%=item.rec_id %>"><% Response.Write(item.id); %></a></td>
              
                 <td><% Response.Write(ddd); %></td>
                 <td><% Response.Write(item.total); %></td>
                 <td><% Response.Write(item.running_price); %></td>
                 <td><% Response.Write(item.recycled_item_name); %></td>
                       <td><% Response.Write(item.recycled_quantity); %></td>
                    <td><% Response.Write(item.user_name); %></td>
                    <td><a  href='searchRecycle.aspx?del=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>
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


