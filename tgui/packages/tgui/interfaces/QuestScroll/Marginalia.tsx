import { useEffect, useState } from 'react';

import {
  formatMinSec,
  marginalia,
  marginaliaLabel,
  marginaliaLine,
} from './shared';

export const WhisperLine = (props: { compass: string; zHint?: string }) => (
  <div style={marginaliaLine}>
    <span style={marginaliaLabel}>卷轴低语道:</span>
    猎物正在{props.compass}
    {props.zHint ? ` (${props.zHint})` : ''}.
  </div>
);

export const ProgressLine = (props: {
  done: number;
  total: number;
  noun: string;
}) => {
  const remaining = Math.max(0, props.total - props.done);
  return (
    <div style={marginaliaLine}>
      <span style={marginaliaLabel}>所控 {props.noun} 之中,</span>
      <b>{props.done}</b> 已伏诛; 尚余 <b>{remaining}</b> 人.
    </div>
  );
};

export const RetrievalProgressLine = (props: {
  done: number;
  total: number;
  noun: string;
}) => {
  const remaining = Math.max(0, props.total - props.done);
  return (
    <div style={marginaliaLine}>
      <span style={marginaliaLabel}>所寻 {props.noun} 之中,</span>
      <b>{props.done}</b> 已寻回; 尚余 <b>{remaining}</b> 件.
    </div>
  );
};

export const BlockadeTimer = (props: { label: string; seconds: number }) => {
  const [remaining, setRemaining] = useState(props.seconds);
  useEffect(() => {
    setRemaining(props.seconds);
  }, [props.seconds]);
  useEffect(() => {
    if (remaining <= 0) return;
    const t = setTimeout(() => setRemaining((s) => Math.max(0, s - 1)), 1000);
    return () => clearTimeout(t);
  }, [remaining]);
  const danger = remaining <= 30;
  return (
    <div style={marginaliaLine}>
      <span style={marginaliaLabel}>{props.label}:</span>
      <span
        style={{
          color: danger ? 'var(--p-seal-red)' : 'var(--p-ink)',
          fontFamily: "'Courier New', monospace",
          fontWeight: 'bold',
        }}
      >
        {formatMinSec(remaining)}
      </span>
    </div>
  );
};

export const Marginalia = (props: { children: React.ReactNode }) => (
  <div style={marginalia}>{props.children}</div>
);
