using GetC
import GetC.@getCFun
@getCFun "libGL" glCheckFramebufferStatusEXT glCheckFramebufferStatusEXT(e::GLenum)::GLenum;
@getCFun "libGL" glGenFramebuffersEXT glGenFramebuffersEXT(n::GLsizei, fbid::Ptr{GLuint})::Void
@getCFun "libGL" glBindFramebufferEXT glBindFramebufferEXT(b::GLenum, fbid::GLuint)::Void
@getCFun "libGL" glGenRenderbuffersEXT glGenRenderbuffersEXT(n::GLsizei, rbid::Ptr{GLuint})::Void
@getCFun "libGL" glBindRenderbufferEXT glBindRenderbufferEXT(n::GLenum, rbid::GLuint)::Void
@getCFun "libGL" glRenderbufferStorageEXT glRenderbufferStorageEXT(target::GLenum,internalFormat::GLenum,width::GLsizei,height::GLsizei)::Void
@getCFun "libGL" glFramebufferRenderbufferEXT glFramebufferRenderbufferEXT(a1::GLenum, a2::GLenum, a3::GLenum, rb::GLuint)::Void;
@getCFun "libGLU" gluQuadricDrawStyle gluQuadricDrawStyle(quad::Ptr{Void},style::GLenum)::Void

GL_FRAMEBUFFER_EXT =0x8D40
GL_DRAW_FRAMEBUFFER_EXT=0x8CA9
GL_RENDERBUFFER_EXT=0x8D41
GL_COLOR_ATTACHMENT0_EXT=0x8CE0
GL_DEPTH_ATTACHMENT_EXT=0x8D00

@getCFun "libGL" glGetDoublev glGetDoublev(pname::GLenum,params::Ptr{GLdouble})::Void
@getCFun "libGL" glGetFloatv glGetFloatv(pname::GLenum,params::Ptr{GLfloat})::Void
@getCFun "libGL" glGetIntegerv glGetIntegerv(pname::GLenum,params::Ptr{GLint})::Void
@getCFun "libGL" glGetLightfv glGetLightfv(light::GLenum,pname::GLenum,params::Ptr{Float32})::Void
@getCFun "libGL" glGetLightiv glGetLightiv(light::GLenum,pname::GLenum,params::Ptr{Uint8})::Void
@getCFun "libGL" glLightModelfv glLightModelfv(pname::GLenum,params::Ptr{GLfloat})::Void
@getCFun "libGL" glLightModeliv glLightModeliv(pname::GLenum,params::Ptr{GLint})::Void
@getCFun "libGL" glMaterialfv glMaterialfv(face::GLenum,pname::GLenum,params::Ptr{Float32})::Void
@getCFun "libGL" glMaterialiv glMaterialiv(face::GLenum,pname::GLenum,params::Ptr{Uint8})::Void
@getCFun "libGL" glGetMaterialfv glGetMaterialfv(face::GLenum,pname::GLenum,params::Ptr{Float32})::Void
@getCFun "libGL" glGetMaterialiv glGetMaterialiv(face::GLenum,pname::GLenum,params::Ptr{Uint8})::Void
@getCFun "libGL" glReadPixels glReadPixels(x::GLint,y::GLint,width::GLsizei,height::GLsizei,format::GLenum,_type::GLenum,pixels::Ptr{Uint8})::Void