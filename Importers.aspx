<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="Importers.aspx.cs" Inherits="Importers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">

         $(function () {
             initdropdown();
         })
         function initdropdown() {
            $(".js-example-placeholder-single").select2({
                placeholder: "...اختار",
                allowClear: true
            });
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="row">
        <div class="col-md-5 ">
            <div class="row box box-success">
        <div class="col-md-12">
            اسم المورد<span class="star-validation">*</span>
           <asp:RequiredFieldValidator  ForeColor="Red" ValidationGroup="a" CssClass="text-red text-bold list-group-item-text" ControlToValidate="client" ID="RequiredFieldValidator2" runat="server" ErrorMessage="ادخل الاسم"></asp:RequiredFieldValidator>
         <asp:TextBox CssClass="form-control" ID="client" runat="server"></asp:TextBox>
               </div>
         
        <div class="col-md-12">
            رقم الهاتف
            <asp:TextBox CssClass="form-control" ID="phone" runat="server"></asp:TextBox>
        </div>
         <div class="col-md-12">
           العنوان
            <asp:TextBox CssClass="form-control" ID="address" runat="server"></asp:TextBox>
        </div>

          <div class="col-md-12">
           <br />
            <asp:Button CssClass="btn btn-success" ValidationGroup="a" CausesValidation="true" OnClick="add_Click" ID="add" Text="اضافه" runat="server" Style="margin-bottom:15px"></asp:Button>
        </div>
                </div>
            </div>
         <div class="col-md-7">

             <div class="box box-success">
            <div class="box-header">
              <h3 class="box-title">الموردين</h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="search..">

                </div>
              </div>
            </div>
                 <br />
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% FactoryDBEntities db = new FactoryDBEntities();
                      DateTime d = DateTime.Now.Date;
                      var x = (from ss in db.importer where ss.roleType==roleType select new { ss}).ToList();
                      if (x != null)
                      {
                       %>
                <tr>
                  <th>#</th>
                  <th>الاسم</th>
                  <th>الهاتف</th>
                  <th>العنوان</th>
                  <th>الحساب</th>
                  <th></th>
                  <th></th>
                </tr>
                  <%int i = 1; foreach (var item in x)

                      { int x_id = int.Parse(item.ss.id.ToString());
                          var daansumation = (from ff in db.importer_account where ff.importer_id == x_id select ff.daan).Sum();
                          var mdeensumation = (from ff in db.importer_account where ff.importer_id == x_id select ff.mdeen).Sum();
                          

                          double ?acc =  mdeensumation-daansumation;
                     %> 
                      
                <tr>
                     <td class="text-bold"><a  href="AccountImporter.aspx?id=<%=item.ss.id %>"> <% Response.Write(i); %></a></td>

                 <td><a  href="AccountImporter.aspx?id=<%=item.ss.id %>"> <% Response.Write(item.ss.name); %></a></td>
                 
                 <td><% Response.Write(item.ss.phone); %></td>
                 <td><% Response.Write(item.ss.address); %></td>
                 <td><% Response.Write(acc); %></td>
                 <td><a  href='Importers.aspx?editid=<%=item.ss.id %>'>  <i class="fa fa-edit text-aqua"></i></a></td>
                  <td><a  href='Importers.aspx?id=<%=item.ss.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>
                </tr>
                    <%  i++;
                            }
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
</asp:Content>



