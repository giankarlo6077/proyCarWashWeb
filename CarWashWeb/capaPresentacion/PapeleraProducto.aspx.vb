Imports System.Data
Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Class capaPresentacion_PapeleraProducto
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        CType(Master, Site_master).OpcionActiva = "papelera"
        If Not IsPostBack Then
            listar()
        End If
    End Sub

    Private Sub listar()
        Try
            Dim obj As New capaNegocio.clsProducto()
            Dim dt As DataTable = obj.listarDadosDeBaja()
            Dim tabla As New DataTable()
            tabla.Columns.Add("Id")
            tabla.Columns.Add("Nombre")
            tabla.Columns.Add("stock")
            tabla.Columns.Add("Precio")
            tabla.Columns.Add("TipoProducto")
            tabla.Columns.Add("Marca")
            For Each fila As DataRow In dt.Rows
                tabla.Rows.Add(fila("idproducto"), fila("producto"), fila("stock"),
                               fila("precioactual"), fila("tipoproducto"), fila("marcaproducto"))
            Next
            tblPapelera.DataSource = tabla
            tblPapelera.DataBind()
        Catch ex As Exception
            mostrar("Error al listar productos dados de baja: " & ex.Message, False)
        End Try
    End Sub

    Private Sub mostrar(ByVal texto As String, ByVal ok As Boolean)
        lblMsg.Text = texto
        lblMsg.CssClass = "msg show " & If(ok, "ok", "err")
    End Sub

    Protected Sub tblPapelera_SelectedIndexChanged(sender As Object, e As EventArgs)
        txtId.Text = tblPapelera.SelectedRow.Cells(0).Text
    End Sub

    Protected Sub btnRecuperar_Click(sender As Object, e As EventArgs) Handles btnRecuperar.Click
        If String.IsNullOrWhiteSpace(txtId.Text) Then
            mostrar("Seleccione un producto para recuperar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsProducto()
            obj.recuperarProducto(Convert.ToInt32(txtId.Text))
            mostrar("PRODUCTO RECUPERADO", True)
            txtId.Text = ""
            listar()
        Catch ex As Exception
            mostrar("Error al recuperar: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnEliminar_Click(sender As Object, e As EventArgs) Handles btnEliminar.Click
        If String.IsNullOrWhiteSpace(txtId.Text) Then
            mostrar("Escoja un ID para eliminar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsProducto()
            obj.eliminarProducto(Convert.ToInt32(txtId.Text))
            mostrar("PRODUCTO ELIMINADO", True)
            txtId.Text = ""
            listar()
        Catch ex As Exception
            mostrar("Error al eliminar: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnActualizar_Click(sender As Object, e As EventArgs) Handles btnActualizar.Click
        txtId.Text = ""
        listar()
    End Sub

End Class
