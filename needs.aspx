<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="needs.aspx.cs" Inherits="needs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
              <h3 class="box-title">النواقص</h3>
              <%--  <asp:Button ID="show" OnClick="show_Click" runat="server" Text="show"  CssClass=" btn bg-aqua"/>
                --%>
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="search..">

                  <%--<div class="input-group-btn">
                    <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
                  </div>--%>
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% 
                      FactoryDBEntities db = new FactoryDBEntities();
                      DateTime d = DateTime.Now.Date;
                      var x = (from ss in db.stock where ss.quantity <= ss.min_quantity &&ss.roleType==roleType select ss).ToList();
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>#</th>
                  <th>الصنف</th>
                  <th>الكود</th>
                  <th>الكميه بالمخزن</th>
                  <th>اقل كميه</th>
                  <th>سعر البيع</th>
                </tr>
                  <% foreach (var item in x)
                      { %> 
                      
                <tr class="bg-danger">
                     <td><% Response.Write(item.id); %></td>

                 <td><% Response.Write(item.name); %></td>
                     <td><% Response.Write(item.code); %></td>
                     <td><% Response.Write(item.quantity); %></td>

                     <td><% Response.Write(item.min_quantity); %></td>

                 <td><% Response.Write(item.price); %></td>

                
                 
                  

                    

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
            input = document.getElementById("search");
            filter = input.value.toUpperCase();
            table = document.getElementById("mytable");
            tr = table.getElementsByTagName("tr");
            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[1];
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

</asp:Content>

