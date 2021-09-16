<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="sub_itemList.aspx.cs" Inherits="sub_itemList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
<div class="row">
        <div class="col-md-5 ">
            <div class="row box box-warning">
        <div class="col-md-7">
            اسم الصنف<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="ادخل اسم الصنف" ControlToValidate="name"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:TextBox CssClass="form-control" ID="name" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
        </div>
          <div class="col-md-12">
           <br />
            <asp:Button CssClass="btn btn-success " OnClick="add_Click" ID="add" Text="اضافه" runat="server" style="margin-bottom:20px"></asp:Button>
             
        </div>
                 <br />
                 
           
                </div>
            
            </div>
    
         <div class="col-md-7">

             <div class="box box-warning">
            <div class="box-header">
              <h3 class="box-title">  الاصنــــاف الرئيسيه</h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="search..">

                </div>
              </div>
            </div>
            <!-- /.box-header -->
                 <br />
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% FactoryDBEntities db = new FactoryDBEntities();
                      var x = (from ss in db.category where ss.roleType==roleType  select ss).OrderBy(a=>a.name).ToList();
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>#</th>
                  <th>الاسم</th>
                 
                  <th></th>
                 <th></th>
                </tr>
                  <% int i = 1;
                    
                      foreach (var item in x)
                      {%>
                <tr>
                 <td><% Response.Write(i); %></td>
                 <td class="text-bold " style="font-size:17px"><a href="addproduct2.aspx?main_id=<%=item.id %>"><% Response.Write(item.name); %></a></td>
               
                  <td><a  href='sub_itemList.aspx?editid=<%=item.id %>'>  <i class="fa fa-edit text-aqua"></i></a></td>
                    
                   <td><a  href='sub_itemList.aspx?del=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>


                    

                </tr>
                    <% i++; }
                          %>
                 
                  <%
    }%>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
         

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


