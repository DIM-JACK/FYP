<?php /* Smarty version 2.6.18, created on 2021-05-28 06:23:14
         compiled from C:/Bitnami/processmaker-3.2.1-0/apps/processmaker/htdocs/gulliver/templates/menu.html */ ?>
<ul id="pm_menu">
	<?php $_from = $this->_tpl_vars['menus']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['name'] => $this->_tpl_vars['field']):
?>
	<?php if ($this->_tpl_vars['field']['icon'] != ""): ?>
	<li  id="<?php echo $this->_tpl_vars['field']['idName']; ?>
" class="<?php echo $this->_tpl_vars['field']['classname']; ?>
">
		<a href="<?php echo $this->_tpl_vars['field']['target']; ?>
" >
			<img src="<?php echo $this->_tpl_vars['field']['icon']; ?>
" border="0" alt="<?php echo $this->_tpl_vars['field']['label']; ?>
"/>
			<?php echo $this->_tpl_vars['field']['label']; ?>

		</a>
	</li>
	<?php else: ?>
	<li  id="<?php echo $this->_tpl_vars['field']['idName']; ?>
"
		  class="<?php echo $this->_tpl_vars['field']['classname']; ?>
">
		<a href="<?php echo $this->_tpl_vars['field']['target']; ?>
">
			<?php echo $this->_tpl_vars['field']['label']; ?>

		</a>
	</li>
	<?php endif; ?>
	<?php endforeach; endif; unset($_from); ?>
</ul>