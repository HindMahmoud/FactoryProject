<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="paymentHistory.aspx.cs" Inherits="paymentHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
     <div class="row" style="overflow-y:auto;height:700px">
        <div class="col-xs-12">
          <div class="box box-danger">
            <div class="box-header">
              <h3 class="box-title"> جميع المصروفات</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="search..">

                  <%--<div class="input-group-btn">
                    <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
                  </div>--%>
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
                      var x = (from ss in db.payment where ss.roleType==roleType select ss).ToList();
                      if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"]))&&!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                      {
                          DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);

                          DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                          x = (from ss in  db.payment where ss.date>=d1 &&ss.date<d2&&ss.roleType==roleType select ss).ToList();

                      }
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>#</th>
                  <th>البيان</th>
                  <th>الملاحظات</th>
                  <th>القيمه</th>
                  <th>النوع</th>

                  <th>التاريخ</th>
                   <th>صوره</th>
                
                  <th></th>
                 
                  <th></th>


                </tr>
                  <% int i = 1; foreach (var item in x)
                      {
                           %> 
                      
                <tr>
                     <td><% Response.Write(i); %></td>

                 <td><% Response.Write(item.title); %></td>
                     <td><% Response.Write(item.notes); %></td>
                     <td><% Response.Write(item.value); %></td>
                     <td><% Response.Write(item.type); %></td>
                    <td><% Response.Write(Convert.ToDateTime(item.date).ToShortDateString()); %></td>
                <%if (item.img != null)
                     { %>
                    <td><a href='photos/<%=item.img %>' target="_blank"><i class="fa fa-file-image-o"></i></a></td>
                    <%}
    else {  %><td></td><%} %>
                 
                  
                    
                   <td><a  href='addpayment.aspx?id=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>

         <td><a href="addpayment.aspx?print=<%=item.id %>">  <i class="fa fa-print text-blue"></i></a></td>

                    

                </tr>
                   <% i++; }
                            %>
                  <tr class="bg-info text-bold text-center">
                      <td colspan="3">الاجمالـــــــــــــــي</td>

                      <td ><%=x.Sum(a=>a.value) %></td>
                      <td colspan="6"></td>
                  </tr>

                  <tr class="bg-info text-bold text-center">
                      <td >نثريه</td>

                      <td ><%=x.Where(a=>a.type=="نثريه").Sum(a=>a.value) %></td>
                       <td >اساسيه</td>

                      <td ><%=x.Where(a=>a.type=="اساسيه").Sum(a=>a.value) %></td>
                       <td >اخري</td>

                      <td ><%=x.Where(a=>a.type==null).Sum(a=>a.value) %></td>
                      <td colspan="4"></td>
                      
                  </tr>
                 <%-- <tr class="bg-info text-bold text-center">
                      <td >خزينه</td>

                      <td ><%=x.Where(a=>a.paystring=="خزينه").Sum(a=>a.value) %></td>
                       <td >بنك</td>

                      <td ><%=x.Where(a=>a.paystring=="بنك").Sum(a=>a.value) %></td>
                       <td >اخري</td>

                      <td ><%=x.Where(a=>a.paystring==null).Sum(a=>a.value) %></td>
                      <td colspan="4"></td>
                      
                  </tr>--%>
                  <%
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

