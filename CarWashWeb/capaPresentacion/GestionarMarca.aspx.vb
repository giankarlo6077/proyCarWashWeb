Imports System.Data
Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Class capaPresentacion_GestionarMarca
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        CType(Master, Site_master).OpcionActiva = "marca"
        If Not IsPostBack Then
            lista()
        End If
    End Sub

    Private Sub lista()
        Try
            Dim obj As New capaNegocio.clsMarca()
            Dim dt As DataTable = obj.listarMarca()
            Dim tabla As New DataTable()
            tabla.Columns.Add("ID")
            tabla.Columns.Add("NOMBRE")
            For Each fila As DataRow In dt.Rows
                tabla.Rows.Add(fila("idmarcaproducto"), fila("marcaproducto"))
            Next
            tblMarca.DataSource = tabla
            tblMarca.DataBind()
        Catch ex As Exception
            mostrar("Error al listar marcas: " & ex.Message, False)
        End Try
    End Sub

    Private Sub limpiar()
        txtIdMarca.Text = ""
        txtNombre.Text = ""
    End Sub

    Private Sub mostrar(ByVal texto As String, ByVal ok As Boolean)
        lblMsg.Text = texto
        lblMsg.CssClass = "msg show " & If(ok, "ok", "err")
    End Sub

    Protected Sub tblMarca_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim fila As GridViewRow = tblMarca.SelectedRow
        txtIdMarca.Text = fila.Cells(0).Text
        txtNombre.Text = fila.Cells(1).Text
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        If txtIdMarca.Text = "" Then
            mostrar("Ingresa por favor el id para buscar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsMarca()
            Dim fila As DataRow = obj.buscarXid(Convert.ToInt32(txtIdMarca.Text))
            If fila IsNot Nothing Then
                txtNombre.Text = Convert.ToString(fila("marcaproducto"))
            Else
                mostrar("No se encontró la marca con ese ID", False)
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
                Dim obj As New capaNegocio.clsMarca()
                Dim id As Integer = obj.generarCodigoMarca()
                obj.registrarMarca(id, txtNombre.Text)
                mostrar("MARCA REGISTRADA", True)
                lista()
            Catch ex As Exception
                mostrar("Error al registrar: " & ex.Message, False)
            End Try
            limpiar()
        End If
    End Sub

    Protected Sub btnModificar_Click(sender As Object, e As EventArgs) Handles btnModificar.Click
        If txtIdMarca.Text = "" Then
            mostrar("Selecciona una marca para modificar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsMarca()
            obj.modificarMarca(Convert.ToInt32(txtIdMarca.Text), txtNombre.Text)
            mostrar("MARCA MODIFICADA", True)
            lista()
            limpiar()
        Catch ex As Exception
            mostrar("Error al modificar: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        limpiar()
    End Sub

    Protected Sub btnEliminar_Click(sender As Object, e As EventArgs) Handles btnEliminar.Click
        If txtIdMarca.Text = "" Then
            mostrar("Selecciona una marca para eliminar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsMarca()
            obj.eliminarMarca(Convert.ToInt32(txtIdMarca.Text))
            mostrar("MARCA ELIMINADA", True)
            lista()
            limpiar()
        Catch ex As Exception
            mostrar("Error al eliminar: " & ex.Message, False)
        End Try
    End Sub

End Class
