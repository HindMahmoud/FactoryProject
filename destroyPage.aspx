<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="destroyPage.aspx.cs" Inherits="destroyPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            { %>

     <br />

    <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
              <h3 class="box-title">مخزن الهالك</h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="بحث باسم الصنف..">

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
                      var x=(from ss in db.stock_destroy where ss.typeRole==roleType select ss).ToList();
             
                if (x != null)
                      {
                       %>
             <tr class="bg-gray-active">

                    <th>#</th>
                    <th>الكود</th>

                  <th>الاسم</th>
                  
                 <th>الكمية </th>
                 
                </tr>
                  <% int i = 1; foreach (var item in x)
                      { float D = 0;
                          var tt = db.stock.Where(a => a.roleType==roleType && a.id == item.id_item).FirstOrDefault();
                          if (tt != null)
                          { D = float.Parse(tt.code); }
                          %>
                      
                <tr>
                 <td ><% Response.Write(i); %></td>
                 <td><% Response.Write(D); %></td>
                 <td><% Response.Write(item.product_name); %></td>
                  <td><% Response.Write(item.quantity); %></td>
                  
                </tr>
                    <% i++; }
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
            input = document.getElementById("search");
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


