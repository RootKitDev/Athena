
<div class="section center z-depth-3">
	<h5>Fréquence des Sauvegardes</h5>
</div><br/>

<div class="container">

<div class="z-depth-1" name="table">
	<table>
		<thead  class="z-depth-2">
			<tr>
				<th data-field="date">Mensuel (Full)</th>
				<th data-field="date">Hebdomadaire (Incrémentiel)</th>
				<th data-field="date">Hebdomadaire (Full)</th>
				<th data-field="date">Journalière (Incrémentiel)</th>
				<th data-field="date">Exeptionnelle (Full)</th>
				<th data-field="date"><strong>DEPLANIFIEES</stong></th>
			</tr>
		</thead>

		<tbody>
			<tr>
			<?php
			if (empty($FlagDP)) {
			?>
				<td>
			<?php
				if (empty($FlagM)) {
			?>
					<i class="small material-icons green-text">done</i>
			<?php
				}
				else {
			?>
					<i class="small material-icons red-text">clear</i>
			<?php
				}
			?>
				</td>

				<td>
			<?php
				if (empty($FlagHi)) {
			?>
					<i class="small material-icons green-text">done</i>
			<?php
				}
				else {
			?>
					<i class="small material-icons red-text">clear</i>
			<?php
				}
			?>
				</td>

				<td>
			<?php
				if (empty($FlagHf)) {
			?>
					<i class="small material-icons green-text">done</i>
			<?php
				}
				else {
			?> 
					<i class="small material-icons red-text">clear</i>
			<?php
				}
			?>
				</td>

				<td>
			<?php
				if (empty($FlagJ)) {
			?>
					<i class="small material-icons green-text">done</i>
			<?php
				}
				else {
			?> 
					<i class="small material-icons red-text">clear</i>
			<?php
				}
			?>
				</td>

				<td>
			<?php
				if (!empty($FlagEx)) {
			?>
					<i class="small material-icons green-text">done</i>
			<?php
				}
				else {
			?> 
					<i class="small material-icons red-text">clear</i>
			<?php
				}
			?>
				</td>

				<td>
					<i class="small material-icons red-text">clear</i>
				</td>
			<?php
			}
			else{
			?>
				<td>
					<i class="small material-icons red-text">clear</i>
				</td>

				<td>
					<i class="small material-icons red-text">clear</i>
				</td>

				<td>
					<i class="small material-icons red-text">clear</i>
				</td>

				<td>
					<i class="small material-icons red-text">clear</i>
				</td>

				<td>
					<i class="small material-icons red-text">clear</i>
				</td>

				<td>
					<i class="small material-icons green-text">done</i>
				</td>
			<?php
			}
			?>
			</tr>
		</tbody>
	</table>
</div>
</div>