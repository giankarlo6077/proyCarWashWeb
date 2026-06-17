Imports System.Data
Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Class capaPresentacion_GestionarTipoProducto
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        CType(Master, Site_master).OpcionActiva = "tipo"
        If Not IsPostBack Then
            listar()
        End If
    End Sub

    Private Sub listar()
        Try
            Dim obj As New capaNegocio.clsTipoProducto()
            Dim dt As DataTable = obj.listarTipoProducto()
            Dim tabla As New DataTable()
            tabla.Columns.Add("ID")
            tabla.Columns.Add("NOMBRE")
            For Each fila As DataRow In dt.Rows
                tabla.Rows.Add(fila("idtipoproducto"), fila("tipoproducto"))
            Next
            tblTipoProducto.DataSource = tabla
            tblTipoProducto.DataBind()
        Catch ex As Exception
            mostrar("Error al listar tipos de producto: " & ex.Message, False)
        End Try
    End Sub

    Private Sub limpiar()
        txtIdTipoProducto.Text = ""
        txtNombre.Text = ""
    End Sub

    Private Sub mostrar(ByVal texto As String, ByVal ok As Boolean)
        lblMsg.Text = texto
        lblMsg.CssClass = "msg show " & If(ok, "ok", "err")
    End Sub

    Protected Sub tblTipoProducto_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim fila As GridViewRow = tblTipoProducto.SelectedRow
        txtIdTipoProducto.Text = fila.Cells(0).Text
        txtNombre.Text = fila.Cells(1).Text
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        If txtIdTipoProducto.Text = "" Then
            mostrar("Ingrese el ID para buscar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsTipoProducto()
            Dim fila As DataRow = obj.buscarXid(Convert.ToInt32(txtIdTipoProducto.Text))
            If fila IsNot Nothing Then
                txtNombre.Text = Convert.ToString(fila("tipoproducto"))
            Else
                mostrar("No se encontró el tipo de producto con ese ID", False)
            End If
        Catch ex As Exception
            mostrar("Error al buscar: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnNuevo_Click(sender As Object, e As EventArgs) Handles btnNuevo.Click
        If btnNuevo.Text = "Nuevo" Then
            btnNuevo.Text = "Guardar"
            limpiar()
        Else
            btnNuevo.Text = "Nuevo"
            Try
                Dim obj As New capaNegocio.clsTipoProducto()
                Dim id As Integer = obj.generarCodigoTipoProducto()
                obj.registrarTipoProducto(id, txtNombre.Text)
                mostrar("TIPO DE PRODUCTO REGISTRADO", True)
            Catch ex As Exception
                mostrar("Error al registrar: " & ex.Message, False)
            End Try
        End If
        limpiar()
        listar()
    End Sub

    Protected Sub btnModificar_Click(sender As Object, e As EventArgs) Handles btnModificar.Click
        If txtIdTipoProducto.Text = "" Then
            mostrar("Por favor seleccione un tipo de producto para modificar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsTipoProducto()
            obj.modificarTipoProducto(Convert.ToInt32(txtIdTipoProducto.Text), txtNombre.Text)
            mostrar("TIPO DE PRODUCTO MODIFICADO", True)
        Catch ex As Exception
            mostrar("Error al modificar: " & ex.Message, False)
        End Try
        limpiar()
        listar()
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        limpiar()
    End Sub

    Protected Sub btnEliminar_Click(sender As Object, e As EventArgs) Handles btnEliminar.Click
        If txtIdTipoProducto.Text = "" Then
            mostrar("Por favor seleccione un tipo de producto para eliminar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsTipoProducto()
            obj.eliminarTipoProducto(Convert.ToInt32(txtIdTipoProducto.Text))
            mostrar("TIPO DE PRODUCTO ELIMINADO", True)
        Catch ex As Exception
            mostrar("Error al eliminar: " & ex.Message, False)
        End Try
        limpiar()
        listar()
    End Sub

End Class
