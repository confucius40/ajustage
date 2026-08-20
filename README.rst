Ajustage
========

A minimal, programmable text editor written in Haskell.

Ajustage is an experimental text editor built around a simple idea:

.. code-block::

   the editor should stay out of your way.

It combines a deliberately minimal graphical interface with Acme-inspired mouse
chording, OpenGL rendering, and a Haskell-based module system.

The goal is not to reproduce existing editors. Ajustage is intended to be a
small, programmable environment for working with text.

Features
--------

- Minimal, uncluttered graphical interface
- OpenGL-based rendering
- Acme-style mouse chording
- Haskell-based editor modules
- Reloadable modules
- Programmable themes written in Haskell
- Syntax highlighting
- Multiple buffers
- Keyboard and mouse driven editing
- Designed around a small editor core

The project is still in development, and many of these features are planned
rather than complete.

Design
------

Ajustage deliberately avoids the conventional "IDE" interface.

There is no requirement for a permanent sidebar, toolbar, tab bar, or large
collection of panels. The default interface is intentionally quiet: a simple
grey background, white text, and a clean system-style font.

Additional functionality should appear when it is useful rather than occupying
space permanently.

Mouse Chording
--------------

Ajustage takes inspiration from the mouse interaction model of Acme.

Mouse buttons are not merely alternative keyboard shortcuts. Chords can be
used to combine actions and operate directly on the text under the pointer.

This interaction model is intended to make the editor feel direct and spatial
rather than menu-driven.

Programmable Themes
-------------------

Themes are Haskell modules rather than static configuration files.

A theme can define the visual appearance of Ajustage using ordinary Haskell
code. This allows themes to be composed, generated, and customized without
inventing a separate configuration language.

A simplified theme may eventually look like:

.. code-block:: haskell

   module Theme.Minimal where

   theme :: Theme
   theme = defaultTheme
       { background = rgb 48 48 48
       , foreground = rgb 240 240 240
       , cursor = rgb 255 255 255
       }

Because themes are modules, they can also participate in Ajustage's
reloadable module system.

Reloadable Modules
------------------

Ajustage is intended to support reloading editor functionality while the
editor is running.

The module system is designed around the idea that the editor itself should
be programmable. Themes, commands, integrations, and other extensions can
eventually be implemented as Haskell modules.

For example, an Ajustage installation might contain modules such as:

.. code-block::

   Theme.Minimal
   Theme.Monochrome
   Ajustage.Acme
   Ajustage.Search
   Ajustage.Git

The exact module API is still being designed.

Rendering
---------

Ajustage uses OpenGL for graphical rendering.

The rendering layer is intended to remain separate from the editor model so
that text editing does not depend directly on the graphics implementation.

A simplified architecture is:

.. code-block::

   Input
     |
     v
   Editor Events
     |
     v
   Commands
     |
     v
   Editor Core
     |
     +-------> Renderer -------> OpenGL
     |
     +-------> Modules
     |
     +-------> Theme

Editor Core
-----------

The core of Ajustage is intentionally small.

The editor model is responsible for text, cursors, selections, and editing
operations. Rendering, input handling, and modules should build on top of
this core rather than becoming part of it.

The project is currently focusing on establishing this core before expanding
the graphical interface and module system.

Building
--------

Ajustage uses Stack.

To build the project:

.. code-block:: console

   stack build

To run it:

.. code-block:: console

   stack run

Development
-----------

Ajustage is currently experimental.

The internal APIs are expected to change while the editor core, renderer,
input system, and module system are developed.

The project is therefore best considered an early-stage experiment rather than
a production-ready text editor.

Project Structure
-----------------

The project is organized around a small core with separate subsystems:

.. code-block::

   ajustage/
   |
   +-- app/
   |   `-- Main.hs
   |
   +-- src/
   |   `-- Ajustage/
   |       +-- Core.hs
   |       +-- Buffer.hs
   |       +-- Input.hs
   |       +-- Render.hs
   |       +-- Theme.hs
   |       `-- Module.hs
   |
   +-- test/
   |   `-- Spec.hs
   |
   +-- package.yaml
   +-- stack.yaml
   `-- README.rst

The structure will evolve as the editor grows.

Philosophy
----------

Ajustage is built around a few principles:

- Keep the interface small.
- Keep the editor core smaller.
- Prefer direct interaction over menus.
- Make the editor programmable.
- Avoid configuration languages when Haskell can express the same thing.
- Make advanced functionality optional rather than permanently visible.
- Let the user decide how their editor behaves.

Status
------

Ajustage is under active development.

The current priority is the editor core: buffers, cursors, text editing,
movement, and the basic abstractions required by the renderer and module
system.

License
-------

Ajustage is free and open-source software.

The project's license will be specified as development progresses.
