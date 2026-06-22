Imports System.Data
Imports capaNegocio

Partial Class jdHistorialMantenimiento
    Inherits System.Web.UI.Page

    Dim objCita As New clsCita()

    Private Sub listar(ByVal dato As String)
        Try
            dgvMantenimientos.DataSource = objCita.listarHistorialCitasMantenimientoporDocumento(dato)
            dgvMantenimientos.DataBind()
        Catch ex As Exception
            lblMensaje.CssClass = "mensaje-error"
            lblMensaje.Text = "Error al listar mantenimientos: " & ex.Message
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        listar(txtbuscador.Text.Trim())
    End Sub
End Class
