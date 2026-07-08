Imports com.somee.wspruebacarwash2

Partial Class MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Usuario") IsNot Nothing Then
            ' Se refresca el nombre desde la BD por si fue modificado en Mantenimiento de Trabajadores
            Try
                Dim objTrabajador As New WSv1
                Dim nombreActual As String = objTrabajador.obtenerNombrePorUsuario(Convert.ToString(Session("Usuario")))
                If nombreActual <> "" Then
                    Session("NombreTrabajador") = nombreActual
                End If
            Catch ex As Exception
                ' Si falla el refresco, se sigue mostrando el último nombre conocido en sesión
            End Try
        End If

        If Not Page.IsPostBack Then
            If Session("NombreTrabajador") IsNot Nothing Then
                lblNombreUsuarioNav.Text = Convert.ToString(Session("NombreTrabajador"))
            Else
                lblNombreUsuarioNav.Text = "Invitado"
            End If
        End If

        ' El módulo "Mantenimiento" solo es visible para el rol Administrador
        phMantenimiento.Visible = Seguridad.EsAdministrador()
    End Sub

    Protected Sub btnCerrarSesion_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("jdInicioSesion.aspx")
    End Sub

End Class