Imports System.Globalization

Partial Class FrmMenuPrincipal
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        ' Protegemos la página: si no hay sesión activa, regresa al login
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            lblNombreTrabajador.Text = Convert.ToString(Session("NombreTrabajador"))

            ' Fecha actual en español (ej: "Domingo, 21 de junio de 2026")
            Dim culturaPeru As New CultureInfo("es-PE")
            lblFechaHoy.Text = Date.Now.ToString("dddd, dd 'de' MMMM 'de' yyyy", culturaPeru)
            lblFechaHoy.Text = Char.ToUpper(lblFechaHoy.Text(0)) & lblFechaHoy.Text.Substring(1)
        End If

    End Sub

End Class